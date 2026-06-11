import 'package:enterprise_flutter_template/app/constants/app_constants.dart';
import 'package:enterprise_flutter_template/core/storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gestión segura de tokens de sesión (access + refresh).
///
/// Encapsula las claves y el almacenamiento seguro para que los interceptores y
/// repositorios trabajen con una API de alto nivel y testeable.
class TokenStorage {
  TokenStorage(this._storage);
  final SecureStorage _storage;

  Future<String?> get accessToken =>
      _storage.read(AppConstants.keyAccessToken);

  Future<String?> get refreshToken =>
      _storage.read(AppConstants.keyRefreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(AppConstants.keyAccessToken, accessToken);
    await _storage.write(AppConstants.keyRefreshToken, refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(AppConstants.keyAccessToken);
    await _storage.delete(AppConstants.keyRefreshToken);
  }
}

/// Provider del gestor de tokens.
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);
