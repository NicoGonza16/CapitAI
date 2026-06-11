import 'package:enterprise_flutter_template/app/constants/app_constants.dart';
import 'package:enterprise_flutter_template/core/network/api_client.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/models/auth_dtos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fuente de datos remota de autenticación.
///
/// Su única responsabilidad es hablar con la API a través del [ApiClient] y
/// devolver DTOs. No contiene lógica de negocio ni de mapeo a dominio (eso es
/// responsabilidad del repositorio).
abstract interface class AuthRemoteDataSource {
  Future<Result<AuthResponseDto>> login(LoginRequestDto request);
}

/// Implementación HTTP de [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);
  final ApiClient _client;

  @override
  Future<Result<AuthResponseDto>> login(LoginRequestDto request) async {
    final result = await _client.post<Map<String, dynamic>>(
      AppConstants.loginEndpoint,
      data: request.toJson(),
    );
    return result.map((response) => AuthResponseDto.fromJson(response.data));
  }
}

/// Provider de la fuente de datos remota.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);
