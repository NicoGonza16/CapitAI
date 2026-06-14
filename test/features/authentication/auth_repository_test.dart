import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/data/models/auth_dtos.dart';
import 'package:enterprise_flutter_template/features/authentication/data/models/user_dto.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthRemoteDataSource remote;
  late MockTokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  const authResponse = AuthResponseDto(
    user: UserDto(id: '1', name: 'Ada', email: 'ada@example.com'),
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  setUpAll(registerCommonFallbacks);

  setUp(() {
    remote = MockAuthRemoteDataSource();
    tokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(remote: remote, tokenStorage: tokenStorage);
  });

  group('AuthRepositoryImpl.login', () {
    test('en éxito persiste tokens y devuelve la entidad User', () async {
      when(() => remote.login(any()))
          .thenAnswer((_) async => const Result.success(authResponse));
      when(() => tokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'ada@example.com',
        password: '123456',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.email, 'ada@example.com');
      verify(() => tokenStorage.saveTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
          ),).called(1);
    });

    test('propaga el error y NO persiste tokens en fallo', () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const Result.failure(ApiException('boom', statusCode: 500)),
      );

      final result = await repository.login(
        email: 'ada@example.com',
        password: '123456',
      );

      expect(result, isA<Failure<User>>());
      verifyNever(() => tokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),);
    });
  });
}
