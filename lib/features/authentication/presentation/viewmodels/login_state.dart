import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

/// Estado del flujo de login.
enum LoginStatus { idle, loading, success, error }

/// Método de autenticación en curso (para mostrar el spinner en el botón
/// correcto).
enum AuthMethod { email, google, apple }

/// Estado inmutable de la pantalla de login gestionado por el ViewModel.
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.activeMethod,
    this.user,
    this.errorMessage,
    this.rememberMe = false,
  });

  final LoginStatus status;
  final AuthMethod? activeMethod;
  final User? user;
  final String? errorMessage;
  final bool rememberMe;

  bool get isLoading => status == LoginStatus.loading;

  /// `true` si el método [method] es el que está cargando ahora mismo.
  bool isLoadingMethod(AuthMethod method) =>
      isLoading && activeMethod == method;

  LoginState copyWith({
    LoginStatus? status,
    AuthMethod? activeMethod,
    User? user,
    String? errorMessage,
    bool? rememberMe,
  }) {
    return LoginState(
      status: status ?? this.status,
      activeMethod: activeMethod,
      user: user ?? this.user,
      errorMessage: errorMessage,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [status, activeMethod, user, errorMessage, rememberMe];
}
