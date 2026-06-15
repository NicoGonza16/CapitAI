# Integración de Firebase Authentication

La app ya tiene toda la lógica de autenticación lista. El único punto de contacto con el proveedor es la interfaz [`AuthService`](../lib/features/authentication/data/services/auth_service.dart). Hoy corre con `FakeAuthService` (simulado). Para usar Firebase real, solo implementa esa interfaz y sobreescribe `authServiceProvider`.

Soporta: **email/contraseña**, **Google** y **Apple (iOS/macOS)**.

---

## 1. Dependencias

```bash
flutter pub add firebase_core firebase_auth google_sign_in sign_in_with_apple crypto
```

## 2. Configurar el proyecto Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Esto genera `lib/firebase_options.dart`. Luego inicializa Firebase en `bootstrap.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.init(flavor);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authServiceProvider.overrideWithValue(FirebaseAuthService()), // <-- activa Firebase
    ],
    child: const App(),
  ));
}
```

## 3. Implementación de `FirebaseAuthService`

Crea `lib/features/authentication/data/services/firebase_auth_service.dart`:

```dart
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/features/authentication/data/services/auth_service.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';

/// Implementación real de [AuthService] con Firebase Authentication.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({fb.FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<User?> authStateChanges() =>
      _auth.authStateChanges().map(_mapUser);

  @override
  Future<User?> currentUser() async => _mapUser(_auth.currentUser);

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
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
  }) async {
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
  Future<AuthResult> signInWithGoogle() async {
    return _guard(() async {
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
  Future<AuthResult> signInWithApple() async {
    return _guard(() async {
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
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) =>
      _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  // `code` es el oobCode del enlace del correo (deep link).
  // Recíbelo con go_router: GoRoute(path: '/reset-password',
  //   builder: (c, s) => ResetPasswordView(code: s.uri.queryParameters['oobCode']!))

  // --- Helpers -------------------------------------------------------------

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

  /// Convierte FirebaseAuthException en la jerarquía AppException del dominio.
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
```

> Nota: el repositorio (`AuthRepositoryImpl`) ya envuelve estas llamadas en `try/catch` y mapea las `AppException` a `Result`. No necesitas tocar nada más en la capa de dominio/presentación.

## 4. Configuración por plataforma

### Android
1. Descarga `google-services.json` → `android/app/`.
2. Añade el plugin de Google Services (lo hace `flutterfire configure` en proyectos recientes).
3. Para Google Sign-In: registra la huella **SHA-1** y **SHA-256** en la consola de Firebase:
   ```bash
   cd android && ./gradlew signingReport
   ```

### iOS
1. Descarga `GoogleService-Info.plist` → `ios/Runner/`.
2. Google Sign-In: añade el `REVERSED_CLIENT_ID` como URL Scheme en `ios/Runner/Info.plist`.
3. Sign in with Apple: en Xcode → target Runner → *Signing & Capabilities* → **+ Sign in with Apple**. Requiere cuenta de Apple Developer de pago.

### Web
`flutterfire configure` inyecta la config. Para Apple/Google en web se usa el flujo de popup automáticamente.

## 5. Consideraciones de UX

- **Apple en Android**: el botón de Apple suele ocultarse en Android (Sign in with Apple es obligatorio solo en iOS si ofreces otros logins sociales). Puedes condicionar su visibilidad con `Platform.isIOS`.
- **Refresh token**: Firebase gestiona la sesión automáticamente; `AuthRepositoryImpl` guarda el ID token para adjuntarlo a tu API propia vía `AuthInterceptor`.
- **Estado de sesión reactivo**: `AuthRepository.authStateChanges()` ya expone el stream de Firebase; el guard de `go_router` reacciona a los cambios.
