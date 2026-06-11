import 'package:dio/dio.dart';
import 'package:enterprise_flutter_template/app/config/environment.dart';
import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:enterprise_flutter_template/core/network/interceptors/logging_interceptor.dart';
import 'package:enterprise_flutter_template/core/network/interceptors/retry_interceptor.dart';
import 'package:enterprise_flutter_template/core/network/network_response.dart';
import 'package:enterprise_flutter_template/core/services/logger_service.dart';
import 'package:enterprise_flutter_template/core/storage/token_storage.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cliente HTTP de alto nivel construido sobre [Dio].
///
/// Centraliza configuración (base URL, timeouts, interceptores) y, sobre todo,
/// la **conversión de errores** de Dio a [AppException]. De este modo ninguna
/// otra capa necesita `try/catch` contra `DioException`: todas las operaciones
/// devuelven un [Result] tipado.
class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  /// Acceso de bajo nivel para casos avanzados (p. ej. interceptores).
  Dio get raw => _dio;

  Future<Result<NetworkResponse<T>>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(() => _dio.get<T>(path, queryParameters: queryParameters));

  Future<Result<NetworkResponse<T>>> post<T>(
    String path, {
    Object? data,
  }) =>
      _request(() => _dio.post<T>(path, data: data));

  Future<Result<NetworkResponse<T>>> put<T>(
    String path, {
    Object? data,
  }) =>
      _request(() => _dio.put<T>(path, data: data));

  Future<Result<NetworkResponse<T>>> delete<T>(String path) =>
      _request(() => _dio.delete<T>(path));

  /// Ejecuta la petición y mapea cualquier error a un [AppException].
  Future<Result<NetworkResponse<T>>> _request<T>(
    Future<Response<T>> Function() send,
  ) async {
    try {
      final response = await send();
      return Result.success(
        NetworkResponse<T>(
          data: response.data as T,
          statusCode: response.statusCode ?? 200,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(UnknownException(message: e.toString(), cause: e));
    }
  }

  /// Traduce un [DioException] a la jerarquía de errores del dominio.
  AppException _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        NetworkException('Tiempo de espera agotado', cause: e),
      DioExceptionType.connectionError =>
        const NetworkException('Sin conexión a internet'),
      DioExceptionType.badResponse => _mapStatusCode(e),
      _ => UnknownException(message: e.message ?? 'Error de red', cause: e),
    };
  }

  AppException _mapStatusCode(DioException e) {
    final code = e.response?.statusCode;
    if (code == 401) {
      return const UnauthorizedException('Sesión expirada o no autorizada');
    }
    return ApiException(
      'Error del servidor (HTTP $code)',
      statusCode: code,
      cause: e,
    );
  }
}

/// Provider del [Dio] configurado con interceptores y reintentos.
final dioProvider = Provider<Dio>((ref) {
  final env = Environment.current;
  final dio = Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: env.connectTimeout,
      receiveTimeout: env.receiveTimeout,
      contentType: 'application/json',
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage: ref.watch(tokenStorageProvider), dio: dio),
    RetryInterceptor(dio: dio),
    LoggingInterceptor(ref.watch(loggerProvider)),
  ]);

  return dio;
});

/// Provider del cliente HTTP de alto nivel.
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);
