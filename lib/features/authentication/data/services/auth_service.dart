import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';

/// Resultado de una autenticación exitosa: usuario + token de sesión.
///
/// El `token` es el ID token del proveedor (Firebase ID token). Se persiste
/// para adjuntarlo en las llamadas a la API propia vía el `AuthInterceptor`.
class AuthResult {
  const AuthResult({required this.user, required this.token});
  final User user;
  final String token;
}

/// Límite de autenticación: ÚNICO punto de contacto con el proveedor (Firebase).
///
/// El resto de la app depende de esta interfaz, nunca de `firebase_auth` /
/// `google_sign_in` / `sign_in_with_apple` directamente. Para activar Firebase
/// basta con implementar esta interfaz (`FirebaseAuthService`) y sobreescribir
/// [authServiceProvider]. Ver `docs/FIREBASE_AUTH.md`.
abstract interface class AuthService {
  /// Emite el usuario actual cada vez que cambia el estado de sesión.
  Stream<User?> authStateChanges();

  /// Usuario actualmente autenticado, o `null` si no hay sesión.
  Future<User?> currentUser();

  /// Inicia sesión con correo y contraseña.
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  });

  /// Inicia sesión con Google.
  Future<AuthResult> signInWithGoogle();

  /// Inicia sesión con Apple (Sign in with Apple — iOS/macOS).
  Future<AuthResult> signInWithApple();

  /// Cierra la sesión en el proveedor.
  Future<void> signOut();
}
