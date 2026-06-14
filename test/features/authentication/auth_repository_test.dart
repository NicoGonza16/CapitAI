import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:enterprise_flutter_template/features/authentication/data/services/auth_service.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthService authService;
  late MockTokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  const user = User(id: '1', name: 'Ada', email: 'ada@example.com');
  const authResult = AuthResult(user: user, token: 'id-token');

  setUp(() {
    authService = MockAuthService();
    tokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      authService: authService,
      tokenStorage: tokenStorage,
    );
    when(() => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),).thenAnswer((_) async {});
  });

  group('AuthRepositoryImpl.login', () {
    test('en éxito persiste el token y devuelve la entidad User', () async {
      when(() => authService.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => authResult);

      final result = await repository.login(
        email: 'ada@example.com',
        password: '123456',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, user);
      verify(() => tokenStorage.saveTokens(
            accessToken: 'id-token',
            refreshToken: 'id-token',
          ),).called(1);
    });

    test('mapea una AppException del servicio a Failure', () async {
      when(() => authService.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenThrow(const UnauthorizedException('credenciales inválidas'));

      final result = await repository.login(
        email: 'ada@example.com',
        password: 'bad',
      );

      expect(result, isA<Failure<User>>());
      verifyNever(() => tokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),);
    });
  });

  group('AuthRepositoryImpl.loginWithGoogle', () {
    test('delega en el servicio y persiste el token', () async {
      when(() => authService.signInWithGoogle())
          .thenAnswer((_) async => authResult);

      final result = await repository.loginWithGoogle();

      expect(result.valueOrNull, user);
      verify(() => authService.signInWithGoogle()).called(1);
    });
  });
}
