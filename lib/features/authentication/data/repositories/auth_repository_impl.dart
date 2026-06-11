import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/storage/token_storage.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:enterprise_flutter_template/features/authentication/data/models/auth_dtos.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';

/// Implementación del [AuthRepository].
///
/// Orquesta la fuente de datos remota y el almacenamiento seguro de tokens, y
/// traduce los DTOs a entidades de dominio. Es el único lugar donde conviven
/// datos remotos y locales para esta feature.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStorage tokenStorage,
  })  : _remote = remote,
        _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(
      LoginRequestDto(email: email, password: password),
    );

    // Mapear el DTO a entidad y persistir los tokens en caso de éxito.
    switch (result) {
      case Success(:final value):
        await _tokenStorage.saveTokens(
          accessToken: value.accessToken,
          refreshToken: value.refreshToken,
        );
        return Result.success(value.user.toEntity());
      case Failure(:final error):
        return Result.failure(error);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _tokenStorage.clear();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheException('No se pudo cerrar sesión', cause: e));
    }
  }

  @override
  Future<Result<User?>> currentUser() async {
    final token = await _tokenStorage.accessToken;
    // En un caso real se decodificaría el JWT o se consultaría /me.
    if (token == null) return const Result.success(null);
    return const Result.success(null);
  }
}
