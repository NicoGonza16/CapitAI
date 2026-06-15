import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/authentication/domain/usecases/request_password_reset_usecase.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider con el correo al que se envió el enlace (para la pantalla de éxito).
final passwordResetEmailProvider = StateProvider<String?>((ref) => null);

/// ViewModel de "Recuperar contraseña" (envío del enlace).
class ForgotPasswordViewModel extends StateNotifier<AuthActionState> {
  ForgotPasswordViewModel(this._useCase) : super(const AuthActionState());

  final RequestPasswordResetUseCase _useCase;

  /// Envía el enlace de recuperación al [email].
  Future<void> sendLink(String email) async {
    state = state.copyWith(status: AuthActionStatus.loading);
    final result = await _useCase(email);
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
final forgotPasswordViewModelProvider = StateNotifierProvider.autoDispose<
    ForgotPasswordViewModel, AuthActionState>(
  (ref) => ForgotPasswordViewModel(
    ref.watch(requestPasswordResetUseCaseProvider),
  ),
);
