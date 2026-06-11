import 'package:equatable/equatable.dart';

/// Excepción base de dominio de la aplicación.
///
/// Todas las capas trabajan con subtipos de [AppException] en lugar de
/// excepciones de librerías externas (Dio, plataforma, etc.). Esto desacopla
/// el dominio de la infraestructura y facilita un manejo de errores uniforme.
sealed class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.cause});

  /// Mensaje legible y seguro para mostrar / loguear.
  final String message;

  /// Causa original (para logging y diagnóstico), nunca expuesta al usuario.
  final Object? cause;

  @override
  List<Object?> get props => [message, runtimeType];

  @override
  String toString() => '$runtimeType: $message';
}

/// Error de red / comunicación con el backend.
final class ApiException extends AppException {
  const ApiException(
    super.message, {
    this.statusCode,
    super.cause,
  });

  /// Código HTTP asociado, si aplica.
  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Error por falta de conectividad o timeout.
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

/// Error de autenticación (401 / token inválido).
final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.cause});
}

/// Error de validación de entrada o de reglas de negocio.
final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

/// Error de caché / almacenamiento local.
final class CacheException extends AppException {
  const CacheException(super.message, {super.cause});
}

/// Error no contemplado.
final class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Ocurrió un error inesperado',
    super.cause,
  });
}
