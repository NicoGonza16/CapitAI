import 'package:dio/dio.dart';
import 'package:enterprise_flutter_template/core/services/logger_service.dart';

/// Interceptor de logging que delega en [LoggerService].
///
/// Solo emite información cuando el ambiente lo permite (controlado por el
/// propio logger), evitando filtrar datos sensibles en producción.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);
  final LoggerService _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warning(
      'xx ${err.response?.statusCode} ${err.requestOptions.uri}',
      err,
    );
    handler.next(err);
  }
}
