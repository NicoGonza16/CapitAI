import 'package:dio/dio.dart';
import 'package:enterprise_flutter_template/app/constants/app_constants.dart';
import 'package:enterprise_flutter_template/core/storage/token_storage.dart';

/// Inyecta el `access token` en cada petición y orquesta el refresh en 401.
///
/// Si el backend responde 401, intenta renovar el token con el refresh token y
/// reintenta la petición original una sola vez. Si falla, propaga el error para
/// que la capa superior cierre la sesión.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  final TokenStorage _tokenStorage;
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized || alreadyRetried) {
      return handler.next(err);
    }

    final refreshed = await _refreshToken();
    if (!refreshed) {
      await _tokenStorage.clear();
      return handler.next(err);
    }

    // Reintenta la petición original con el nuevo token.
    final newToken = await _tokenStorage.accessToken;
    final options = err.requestOptions
      ..headers['Authorization'] = 'Bearer $newToken'
      ..extra['retried'] = true;

    try {
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Intenta renovar el access token usando el refresh token almacenado.
  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenStorage.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        AppConstants.refreshEndpoint,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'retried': true}),
      );
      final data = response.data;
      if (data == null) return false;

      await _tokenStorage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
