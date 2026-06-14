import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase loginUseCase;
  late MockAuthController authController;
  late LoginViewModel viewModel;

  const user = User(id: '1', name: 'Ada', email: 'ada@example.com');

  setUpAll(registerCommonFallbacks);

  setUp(() {
    loginUseCase = MockLoginUseCase();
    authController = MockAuthController();
    viewModel = LoginViewModel(
      loginUseCase: loginUseCase,
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
}
