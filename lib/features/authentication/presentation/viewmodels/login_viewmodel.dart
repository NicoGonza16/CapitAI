import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/usecases/login_usecase.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel del login (patrón MVVM).
///
/// Ejemplo de [StateNotifier]: contiene TODA la lógica de presentación del
/// login. La View solo observa [LoginState] y delega acciones aquí; no contiene
/// lógica de negocio. Al tener éxito, notifica al [AuthController] global.
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel({
    required LoginUseCase loginUseCase,
    required AuthController authController,
  })  : _loginUseCase = loginUseCase,
        _authController = authController,
        super(const LoginState());

  final LoginUseCase _loginUseCase;
  final AuthController _authController;

  /// Ejecuta el login y actualiza el estado según el resultado.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: LoginStatus.loading);

    final result = await _loginUseCase(email: email, password: password);

    switch (result) {
      case Success(:final value):
        _authController.setAuthenticated(value);
        state = state.copyWith(status: LoginStatus.success, user: value);
      case Failure(:final error):
        state = state.copyWith(
          status: LoginStatus.error,
          errorMessage: error.message,
        );
    }
  }
}

/// Provider del ViewModel de login.
final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    loginUseCase: ref.watch(loginUseCaseProvider),
    authController: ref.watch(authControllerProvider.notifier),
  ),
);
