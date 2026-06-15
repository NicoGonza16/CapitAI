import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase useCase;

  const user = User(id: '1', name: 'Ana', email: 'ana@example.com');

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  group('RegisterUseCase', () {
    test('falla si el nombre está vacío', () async {
      final result = await useCase(
        name: '   ',
        email: 'ana@example.com',
        password: 'Abcdef1!',
      );

      expect((result as Failure).error, isA<ValidationException>());
      verifyNever(() => repository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),);
    });

    test('falla si la contraseña tiene menos de 8 caracteres', () async {
      final result = await useCase(
        name: 'Ana',
        email: 'ana@example.com',
        password: '1234567',
      );

      expect((result as Failure).error, isA<ValidationException>());
    });

    test('delega en el repositorio con datos válidos', () async {
      when(() => repository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => const Result.success(user));

      final result = await useCase(
        name: 'Ana',
        email: 'ana@example.com',
        password: 'Abcdef1!',
      );

      expect(result, isA<Success<User>>());
      verify(() => repository.register(
            name: 'Ana',
            email: 'ana@example.com',
            password: 'Abcdef1!',
          ),).called(1);
    });
  });
}
