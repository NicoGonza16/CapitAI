import 'package:capitai/app/config/environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Servicio de logging centralizado.
///
/// Encapsula la librería [Logger] tras una interfaz propia para que el resto de
/// la app no dependa de ella directamente. En producción se silencian los logs
/// de depuración para no filtrar información sensible.
abstract interface class LoggerService {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message);
  void warning(String message, [Object? error]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// Implementación basada en el paquete `logger`.
class AppLogger implements LoggerService {
  AppLogger({required bool enabled})
      : _logger = Logger(
          filter: enabled ? DevelopmentFilter() : ProductionFilter(),
          printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5),
        );

  final Logger _logger;

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void info(String message) => _logger.i(message);

  @override
  void warning(String message, [Object? error]) =>
      _logger.w(message, error: error);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

/// Provider del logger. Se ajusta automáticamente según el ambiente activo.
final loggerProvider = Provider<LoggerService>((ref) {
  return AppLogger(enabled: Environment.current.enableLogging);
});
