import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:capitai/features/authentication/domain/usecases/register_usecase.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel de la pantalla de registro (patrón MVVM).
///
/// Gestiona el alta por correo (vía [RegisterUseCase], que valida) y los
/// proveedores sociales (vía [AuthRepository]). La View solo observa el estado.
class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel({
    required RegisterUseCase registerUseCase,
    required AuthRepository authRepository,
    required AuthController authController,
  })  : _registerUseCase = registerUseCase,
        _authRepository = authRepository,
        _authController = authController,
        super(const RegisterState());

  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;
  final AuthController _authController;

  /// Crea la cuenta con correo y contraseña.
  ///
  /// En éxito NO autentica todavía: la sesión se inicia tras verificar la cuenta
  /// (paso 2). La View navega a la verificación al detectar [LoginStatus.success]
  /// con [AuthMethod.email].
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _start(AuthMethod.email);
    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
    );
    switch (result) {
      case Success(:final value):
        // activeMethod debe preservarse para que la View navegue a verificación.
        state = state.copyWith(
          status: LoginStatus.success,
          activeMethod: AuthMethod.email,
          user: value,
        );
      case Failure(:final error):
        state = state.copyWith(
          status: LoginStatus.error,
          errorMessage: error.message,
        );
    }
  }

  /// Registro/acceso con Google (sin verificación: entra directo).
  Future<void> signInWithGoogle() async {
    _start(AuthMethod.google);
    _handleSocial(await _authRepository.loginWithGoogle());
  }

  /// Registro/acceso con Apple (iOS/macOS, sin verificación).
  Future<void> signInWithApple() async {
    _start(AuthMethod.apple);
    _handleSocial(await _authRepository.loginWithApple());
  }

  /// Activa/desactiva la aceptación de términos.
  void setAcceptedTerms(bool value) =>
      state = state.copyWith(acceptedTerms: value);

  void _start(AuthMethod method) =>
      state = state.copyWith(status: LoginStatus.loading, activeMethod: method);

  void _handleSocial(Result<User> result) {
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

/// Provider del ViewModel de registro.
final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, RegisterState>(
  (ref) => RegisterViewModel(
    registerUseCase: ref.watch(registerUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
    authController: ref.watch(authControllerProvider.notifier),
  ),
);
