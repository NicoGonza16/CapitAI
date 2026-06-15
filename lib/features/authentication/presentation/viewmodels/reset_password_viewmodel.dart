import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel de "Nueva contraseña" (restablecimiento con el código del enlace).
class ResetPasswordViewModel extends StateNotifier<AuthActionState> {
  ResetPasswordViewModel(this._useCase) : super(const AuthActionState());

  final ResetPasswordUseCase _useCase;

  /// Restablece la contraseña con el [code] del enlace y la [newPassword].
  Future<void> submit({
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthActionStatus.loading);
    final result = await _useCase(code: code, newPassword: newPassword);
    state = switch (result) {
      Success() => state.copyWith(status: AuthActionStatus.success),
      Failure(:final error) => state.copyWith(
          status: AuthActionStatus.error,
          errorMessage: error.message,
        ),
    };
  }
}

/// Provider del ViewModel.
final resetPasswordViewModelProvider =
    StateNotifierProvider.autoDispose<ResetPasswordViewModel, AuthActionState>(
  (ref) => ResetPasswordViewModel(ref.watch(resetPasswordUseCaseProvider)),
);
