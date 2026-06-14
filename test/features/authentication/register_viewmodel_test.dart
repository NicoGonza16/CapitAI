import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/register_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockRegisterUseCase registerUseCase;
  late MockAuthRepository authRepository;
  late MockAuthController authController;
  late RegisterViewModel viewModel;

  const user = User(id: '1', name: 'Ana', email: 'ana@example.com');

  setUpAll(registerCommonFallbacks);

  setUp(() {
    registerUseCase = MockRegisterUseCase();
    authRepository = MockAuthRepository();
    authController = MockAuthController();
    viewModel = RegisterViewModel(
      registerUseCase: registerUseCase,
      authRepository: authRepository,
      authController: authController,
    );
  });

  test('setAcceptedTerms actualiza el estado', () {
    viewModel.setAcceptedTerms(true);
    expect(viewModel.state.acceptedTerms, isTrue);
  });

  test('register en éxito notifica al AuthController', () async {
    when(() => registerUseCase(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),).thenAnswer((_) async => const Result.success(user));

    await viewModel.register(
      name: 'Ana',
      email: 'ana@example.com',
      password: '12345678',
    );

    expect(viewModel.state.status, LoginStatus.success);
    verify(() => authController.setAuthenticated(user)).called(1);
  });

  test('register en fallo expone el mensaje de error', () async {
    when(() => registerUseCase(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),).thenAnswer(
      (_) async => const Result.failure(ValidationException('Correo inválido')),
    );

    await viewModel.register(
      name: 'Ana',
      email: 'bad',
      password: '12345678',
    );

    expect(viewModel.state.status, LoginStatus.error);
    expect(viewModel.state.errorMessage, 'Correo inválido');
    verifyNever(() => authController.setAuthenticated(any()));
  });
}
