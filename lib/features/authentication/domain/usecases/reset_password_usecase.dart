import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/password_strength.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caso de uso: restablecer la contraseña con el código del enlace.
///
/// Valida que la nueva contraseña cumpla todos los requisitos de seguridad
/// antes de delegar en el repositorio.
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call({
    required String code,
    required String newPassword,
  }) async {
    if (!PasswordStrength.of(newPassword).isValid) {
      return const Result.failure(
        ValidationException('La contraseña no cumple los requisitos'),
      );
    }
    return _repository.resetPassword(code: code, newPassword: newPassword);
  }
}

/// Provider del caso de uso.
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>(
  (ref) => ResetPasswordUseCase(ref.watch(authRepositoryProvider)),
);
