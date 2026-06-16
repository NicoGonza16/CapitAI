import 'dart:async';

import 'package:capitai/features/authentication/data/services/auth_service.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Implementación simulada de [AuthService] para desarrollo y pruebas de UI.
///
/// Permite que el flujo completo de login funcione SIN configurar Firebase.
/// Reemplázala por `FirebaseAuthService` sobreescribiendo [authServiceProvider]
/// cuando integres Firebase (ver `docs/FIREBASE_AUTH.md`).
class FakeAuthService implements AuthService {
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();
  User? _current;

  static const _latency = Duration(milliseconds: 900);

  @override
  Stream<User?> authStateChanges() => _controller.stream;

  @override
  Future<User?> currentUser() async => _current;

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    final user = User(
      id: 'fake-${email.hashCode}',
      name: email.split('@').first,
      email: email,
    );
    return _authenticate(user);
  }

  @override
  Future<AuthResult> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    return _authenticate(
      User(id: 'fake-${email.hashCode}', name: name, email: email),
    );
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    await Future<void>.delayed(_latency);
    return _authenticate(
      const User(id: 'fake-google', name: 'Google User', email: 'user@gmail.com'),
    );
  }

  @override
  Future<AuthResult> signInWithApple() async {
    await Future<void>.delayed(_latency);
    return _authenticate(
      const User(id: 'fake-apple', name: 'Apple User', email: 'user@icloud.com'),
    );
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  @override
  Future<void> sendEmailVerification() async =>
      Future<void>.delayed(_latency);

  @override
  Future<bool> isEmailVerified() async {
    await Future<void>.delayed(_latency);
    return true; // En desarrollo, el correo se considera verificado.
  }

  @override
  Future<void> sendPasswordReset(String email) async =>
      Future<void>.delayed(_latency);

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async =>
      Future<void>.delayed(_latency);

  AuthResult _authenticate(User user) {
    _current = user;
    _controller.add(user);
    return AuthResult(user: user, token: 'fake-id-token-${user.id}');
  }

  /// Libera el stream controller.
  void dispose() => _controller.close();
}

/// Provider del servicio de autenticación.
///
/// Hoy devuelve [FakeAuthService]. Para usar Firebase, sobreescríbelo en
/// `main.dart`:
/// ```dart
/// authServiceProvider.overrideWithValue(FirebaseAuthService())
/// ```
final authServiceProvider = Provider<AuthService>((ref) {
  final service = FakeAuthService();
  ref.onDispose(service.dispose);
  return service;
});
