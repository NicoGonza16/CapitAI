import 'package:capitai/core/exceptions/app_exception.dart';
import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase loginUseCase;
  late MockAuthRepository authRepository;
  late MockAuthController authController;
  late LoginViewModel viewModel;

  const user = User(id: '1', name: 'Ada', email: 'ada@example.com');

  setUpAll(registerCommonFallbacks);

  setUp(() {
    loginUseCase = MockLoginUseCase();
    authRepository = MockAuthRepository();
    authController = MockAuthController();
    viewModel = LoginViewModel(
      loginUseCase: loginUseCase,
      authRepository: authRepository,
      authController: authController,
    );
  });

  group('LoginViewModel.login', () {
    test('transita a success y notifica al AuthController en éxito', () async {
      when(() => loginUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => const Result.success(user));

      await viewModel.login(email: 'ada@example.com', password: '123456');

      expect(viewModel.state.status, LoginStatus.success);
      expect(viewModel.state.user, user);
      verify(() => authController.setAuthenticated(user)).called(1);
    });

    test('transita a error y expone el mensaje en fallo', () async {
      when(() => loginUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer(
        (_) async => const Result.failure(UnauthorizedException('Credenciales')),
      );

      await viewModel.login(email: 'ada@example.com', password: 'wrongpass');

      expect(viewModel.state.status, LoginStatus.error);
      expect(viewModel.state.errorMessage, 'Credenciales');
      verifyNever(() => authController.setAuthenticated(any()));
    });
  });

  group('LoginViewModel.signInWithGoogle', () {
    test('delega en el repositorio y marca el método activo', () async {
      when(() => authRepository.loginWithGoogle())
          .thenAnswer((_) async => const Result.success(user));

      await viewModel.signInWithGoogle();

      expect(viewModel.state.status, LoginStatus.success);
      verify(() => authRepository.loginWithGoogle()).called(1);
      verify(() => authController.setAuthenticated(user)).called(1);
    });
  });
}
