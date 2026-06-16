import 'package:equatable/equatable.dart';

/// Estado de una acción asíncrona simple de autenticación (sin payload).
enum AuthActionStatus { idle, loading, success, error }

/// Estado reutilizable para acciones como enviar enlace o restablecer
/// contraseña.
class AuthActionState extends Equatable {
  const AuthActionState({
    this.status = AuthActionStatus.idle,
    this.errorMessage,
  });

  final AuthActionStatus status;
  final String? errorMessage;

  bool get isLoading => status == AuthActionStatus.loading;
  bool get isSuccess => status == AuthActionStatus.success;

  AuthActionState copyWith({
    AuthActionStatus? status,
    String? errorMessage,
  }) {
    return AuthActionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
