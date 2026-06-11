import 'package:dio/dio.dart';

/// Reintenta peticiones ante errores transitorios de red (timeout/conexión).
///
/// Aplica un backoff lineal simple. No reintenta respuestas 4xx/5xx, ya que un
/// reintento ciego de errores del servidor rara vez ayuda y puede amplificar
/// carga; eso se delega a estrategias específicas (p. ej. refresh en 401).
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 400),
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  static const _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isTransient(err)) return handler.next(err);

    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;
    if (attempt >= maxRetries) return handler.next(err);

    await Future<void>.delayed(baseDelay * (attempt + 1));

    final options = err.requestOptions
      ..extra[_attemptKey] = attempt + 1;

    try {
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _isTransient(DioException err) =>
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.sendTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.connectionError;
}
