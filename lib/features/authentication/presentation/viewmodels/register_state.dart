import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:equatable/equatable.dart';

/// Estado inmutable de la pantalla de registro.
///
/// Reutiliza [LoginStatus] y [AuthMethod] (compartidos por el flujo de auth) y
/// añade la aceptación de términos, que condiciona el botón de registro.
class RegisterState extends Equatable {
  const RegisterState({
    this.status = LoginStatus.idle,
    this.activeMethod,
    this.user,
    this.errorMessage,
    this.acceptedTerms = false,
  });

  final LoginStatus status;
  final AuthMethod? activeMethod;
  final User? user;
  final String? errorMessage;
  final bool acceptedTerms;

  bool get isLoading => status == LoginStatus.loading;

  bool isLoadingMethod(AuthMethod method) =>
      isLoading && activeMethod == method;

  RegisterState copyWith({
    LoginStatus? status,
    AuthMethod? activeMethod,
    User? user,
    String? errorMessage,
    bool? acceptedTerms,
  }) {
    return RegisterState(
      status: status ?? this.status,
      activeMethod: activeMethod,
      user: user ?? this.user,
      errorMessage: errorMessage,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }

  @override
  List<Object?> get props =>
      [status, activeMethod, user, errorMessage, acceptedTerms];
}
