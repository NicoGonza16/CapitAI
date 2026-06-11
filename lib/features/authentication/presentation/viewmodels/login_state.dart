import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

/// Estados posibles del flujo de login.
enum LoginStatus { idle, loading, success, error }

/// Estado inmutable del formulario de login gestionado por el ViewModel.
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.user,
    this.errorMessage,
  });

  final LoginStatus status;
  final User? user;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;

  /// Crea una copia modificando solo los campos indicados.
  LoginState copyWith({
    LoginStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
