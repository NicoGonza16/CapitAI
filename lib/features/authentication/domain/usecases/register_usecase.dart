import 'package:enterprise_flutter_template/app/constants/app_constants.dart';
import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caso de uso: crear una cuenta.
///
/// Valida la entrada (nombre, correo y longitud mínima de contraseña de
/// registro) antes de delegar en el repositorio. Mantener la regla aquí la hace
/// reutilizable y testeable de forma aislada.
class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<User>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      return const Result.failure(ValidationException('Nombre requerido'));
    }
    if (!Validators.isValidEmail(email)) {
      return const Result.failure(ValidationException('Correo inválido'));
    }
    if (password.length < AppConstants.minSignUpPasswordLength) {
      return const Result.failure(ValidationException('Contraseña muy corta'));
    }
    return _repository.register(name: name, email: email, password: password);
  }
}

/// Provider del caso de uso de registro.
final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);
