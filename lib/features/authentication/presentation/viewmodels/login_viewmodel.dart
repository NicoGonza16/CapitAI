import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:capitai/features/authentication/domain/usecases/login_usecase.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel del login (patrón MVVM).
///
/// Contiene TODA la lógica de presentación del login: email/contraseña (vía
/// [LoginUseCase], que valida) y proveedores sociales Google/Apple (vía
/// [AuthRepository]). La View solo observa [LoginState] y delega acciones.
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel({
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
    required AuthController authController,
  })  : _loginUseCase = loginUseCase,
        _authRepository = authRepository,
        _authController = authController,
        super(const LoginState());

  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;
  final AuthController _authController;

  /// Inicia sesión con correo y contraseña.
  Future<void> login({required String email, required String password}) async {
    _start(AuthMethod.email);
    _handle(await _loginUseCase(email: email, password: password));
  }

  /// Inicia sesión con Google.
  Future<void> signInWithGoogle() async {
    _start(AuthMethod.google);
    _handle(await _authRepository.loginWithGoogle());
  }

  /// Inicia sesión con Apple (iOS/macOS).
  Future<void> signInWithApple() async {
    _start(AuthMethod.apple);
    _handle(await _authRepository.loginWithApple());
  }

  /// Activa/desactiva "Recordarme".
  void setRememberMe(bool value) =>
      state = state.copyWith(rememberMe: value);

  void _start(AuthMethod method) =>
      state = state.copyWith(status: LoginStatus.loading, activeMethod: method);

  void _handle(Result<User> result) {
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
    authRepository: ref.watch(authRepositoryProvider),
    authController: ref.watch(authControllerProvider.notifier),
  ),
);
