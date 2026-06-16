import 'dart:convert';
import 'dart:math';

import 'package:capitai/core/exceptions/app_exception.dart';
import 'package:capitai/features/authentication/data/services/auth_service.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Implementación real de [AuthService] con Firebase Authentication.
///
/// Único punto de contacto con `firebase_auth` / `google_sign_in` /
/// `sign_in_with_apple`. Traduce los errores del proveedor a [AppException]
/// para que el repositorio los envuelva en `Result`.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({fb.FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges().map(_mapUser);

  @override
  Future<User?> currentUser() async => _mapUser(_auth.currentUser);

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _result(cred.user!);
    });
  }

  @override
  Future<AuthResult> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();
      return _result(_auth.currentUser!);
    });
  }

  @override
  Future<AuthResult> signInWithGoogle() {
    return _guard(() async {
      // En web, el popup de Firebase es el flujo soportado (google_sign_in v6
      // no soporta `signIn()` imperativo en web).
      if (kIsWeb) {
        final cred = await _auth.signInWithPopup(fb.GoogleAuthProvider());
        return _result(cred.user!);
      }
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const UnauthorizedException('Inicio con Google cancelado');
      }
      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      return _result(cred.user!);
    });
  }

  @override
  Future<AuthResult> signInWithApple() {
    return _guard(() async {
      // En web, `sign_in_with_apple` no funciona sin configuración especial;
      // se usa el popup de Firebase (requiere el proveedor Apple configurado en
      // la consola con su Service ID).
      if (kIsWeb) {
        final provider = fb.OAuthProvider('apple.com')
          ..addScope('email')
          ..addScope('name');
        final cred = await _auth.signInWithPopup(provider);
        return _result(cred.user!);
      }
      final rawNonce = _generateNonce();
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: _sha256(rawNonce),
      );
      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final cred = await _auth.signInWithCredential(oauthCredential);
      return _result(cred.user!);
    });
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async =>
      _auth.currentUser?.sendEmailVerification();

  @override
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) =>
      _auth.confirmPasswordReset(code: code, newPassword: newPassword);

  // --- Helpers ---------------------------------------------------------------

  Future<AuthResult> _result(fb.User user) async {
    final token = await user.getIdToken() ?? '';
    return AuthResult(user: _mapUser(user)!, token: token);
  }

  User? _mapUser(fb.User? user) {
    if (user == null) return null;
    return User(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@').first ?? 'Usuario',
      email: user.email ?? '',
    );
  }

  /// Traduce [fb.FirebaseAuthException] a la jerarquía [AppException].
  Future<AuthResult> _guard(Future<AuthResult> Function() run) async {
    try {
      return await run();
    } on fb.FirebaseAuthException catch (e) {
      throw switch (e.code) {
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          const UnauthorizedException('Correo o contraseña incorrectos'),
        'email-already-in-use' =>
          const ValidationException('Ese correo ya está registrado'),
        'weak-password' =>
          const ValidationException('La contraseña es demasiado débil'),
        'network-request-failed' =>
          const NetworkException('Sin conexión a internet'),
        _ => UnknownException(message: e.message ?? e.code, cause: e),
      };
    }
  }

  String _generateNonce([int length = 32]) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  String _sha256(String input) =>
      sha256.convert(utf8.encode(input)).toString();
}
