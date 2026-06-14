import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';

/// Contrato del repositorio de autenticación (capa de dominio).
///
/// La capa de presentación y los casos de uso dependen de esta abstracción, no
/// de su implementación concreta ni del proveedor (Firebase) — Dependency
/// Inversion, la "D" de SOLID.
abstract interface class AuthRepository {
  /// Emite el usuario actual cada vez que cambia el estado de sesión.
  Stream<User?> authStateChanges();

  /// Inicia sesión con [email] y [password].
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  /// Inicia sesión con Google.
  Future<Result<User>> loginWithGoogle();

  /// Inicia sesión con Apple (iOS/macOS).
  Future<Result<User>> loginWithApple();

  /// Cierra la sesión y limpia los tokens locales.
  Future<Result<void>> logout();

  /// Recupera el usuario actual si existe una sesión válida.
  Future<Result<User?>> currentUser();
}
