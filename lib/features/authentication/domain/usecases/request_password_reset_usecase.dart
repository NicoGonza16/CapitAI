import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caso de uso: solicitar enlace de recuperación de contraseña.
class RequestPasswordResetUseCase {
  const RequestPasswordResetUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call(String email) async {
    if (!Validators.isValidEmail(email)) {
      return const Result.failure(ValidationException('Correo inválido'));
    }
    return _repository.requestPasswordReset(email);
  }
}

/// Provider del caso de uso.
final requestPasswordResetUseCaseProvider =
    Provider<RequestPasswordResetUseCase>(
  (ref) => RequestPasswordResetUseCase(ref.watch(authRepositoryProvider)),
);
