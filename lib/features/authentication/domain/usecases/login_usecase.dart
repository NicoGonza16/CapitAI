import 'package:capitai/core/exceptions/app_exception.dart';
import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/core/utilities/validators.dart';
import 'package:capitai/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caso de uso: iniciar sesión.
///
/// Encapsula la regla de negocio de login, incluyendo la validación de entrada
/// previa a la llamada de red. Mantener esto fuera del ViewModel hace que la
/// regla sea reutilizable y testeable de forma aislada.
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  /// Ejecuta el inicio de sesión validando primero las credenciales.
  Future<Result<User>> call({
    required String email,
    required String password,
  }) async {
    if (!Validators.isValidEmail(email)) {
      return const Result.failure(ValidationException('Correo inválido'));
    }
    if (!Validators.isValidPassword(password)) {
      return const Result.failure(ValidationException('Contraseña inválida'));
    }
    return _repository.login(email: email, password: password);
  }
}

/// Provider del caso de uso de login.
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);
