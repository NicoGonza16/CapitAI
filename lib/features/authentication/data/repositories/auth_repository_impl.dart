import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/storage/token_storage.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/services/auth_service.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';

/// Implementación del [AuthRepository].
///
/// Orquesta el [AuthService] (proveedor de identidad) y el almacenamiento
/// seguro de tokens, y traduce cualquier excepción a la jerarquía [AppException]
/// envuelta en [Result]. Es el único lugar con `try/catch` de autenticación.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required TokenStorage tokenStorage,
  })  : _authService = authService,
        _tokenStorage = tokenStorage;

  final AuthService _authService;
  final TokenStorage _tokenStorage;

  @override
  Stream<User?> authStateChanges() => _authService.authStateChanges();

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) =>
      _runSignIn(() => _authService.signInWithEmail(
            email: email,
            password: password,
          ),);

  @override
  Future<Result<User>> loginWithGoogle() =>
      _runSignIn(_authService.signInWithGoogle);

  @override
  Future<Result<User>> loginWithApple() =>
      _runSignIn(_authService.signInWithApple);

  @override
  Future<Result<void>> logout() async {
    try {
      await _authService.signOut();
      await _tokenStorage.clear();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheException('No se pudo cerrar sesión', cause: e));
    }
  }

  @override
  Future<Result<User?>> currentUser() async {
    try {
      return Result.success(await _authService.currentUser());
    } catch (_) {
      return const Result.success(null);
    }
  }

  /// Ejecuta un inicio de sesión, persiste el token y mapea errores a [Result].
  Future<Result<User>> _runSignIn(
    Future<AuthResult> Function() action,
  ) async {
    try {
      final result = await action();
      await _tokenStorage.saveTokens(
        accessToken: result.token,
        refreshToken: result.token,
      );
      return Result.success(result.user);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(UnknownException(message: e.toString(), cause: e));
    }
  }
}
