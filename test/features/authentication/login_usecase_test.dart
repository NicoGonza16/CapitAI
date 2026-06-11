import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  const user = User(id: '1', name: 'Ada', email: 'ada@example.com');

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('devuelve ValidationException si el email es inválido', () async {
      final result = await useCase(email: 'no-email', password: '123456');

      expect(result, isA<Failure<User>>());
      expect((result as Failure).error, isA<ValidationException>());
      verifyNever(() => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('devuelve ValidationException si la contraseña es muy corta', () async {
      final result = await useCase(email: 'ada@example.com', password: '12');

      expect(result, isA<Failure<User>>());
      expect((result as Failure).error, isA<ValidationException>());
    });

    test('delega en el repositorio cuando las credenciales son válidas',
        () async {
      when(() => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Result.success(user));

      final result = await useCase(
        email: 'ada@example.com',
        password: '123456',
      );

      expect(result, isA<Success<User>>());
      expect((result as Success).value, user);
      verify(() => repository.login(
            email: 'ada@example.com',
            password: '123456',
          )).called(1);
    });
  });
}
