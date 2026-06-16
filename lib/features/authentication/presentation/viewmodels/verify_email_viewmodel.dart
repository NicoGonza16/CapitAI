import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel de "Verifica tu correo" (paso 2 con enlace de verificación).
///
/// Al crearse envía el enlace de verificación. Expone reenviar y comprobar si
/// el correo ya fue verificado (estado `success` → continuar).
class VerifyEmailViewModel extends StateNotifier<AuthActionState> {
  VerifyEmailViewModel(this._repository) : super(const AuthActionState()) {
    sendLink();
  }

  final AuthRepository _repository;

  /// Envía (o reenvía) el enlace de verificación al correo del usuario.
  Future<void> sendLink() async {
    await _repository.sendEmailVerification();
  }

  /// Comprueba si el correo ya está verificado.
  ///
  /// `success` → verificado (la View continúa). `error` con mensaje → aún no.
  Future<void> checkVerified() async {
    state = state.copyWith(status: AuthActionStatus.loading);
    final result = await _repository.checkEmailVerified();
    state = switch (result) {
      Success(:final value) => value
          ? state.copyWith(status: AuthActionStatus.success)
          : state.copyWith(
              status: AuthActionStatus.error,
              errorMessage: 'not-verified',
            ),
      Failure(:final error) => state.copyWith(
          status: AuthActionStatus.error,
          errorMessage: error.message,
        ),
    };
  }
}

/// Provider del ViewModel.
final verifyEmailViewModelProvider =
    StateNotifierProvider.autoDispose<VerifyEmailViewModel, AuthActionState>(
  (ref) => VerifyEmailViewModel(ref.watch(authRepositoryProvider)),
);
