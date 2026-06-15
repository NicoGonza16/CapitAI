import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/forgot_password_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/reset_password_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  group('ForgotPasswordViewModel', () {
    late MockRequestPasswordResetUseCase useCase;
    late ForgotPasswordViewModel viewModel;

    setUp(() {
      useCase = MockRequestPasswordResetUseCase();
      viewModel = ForgotPasswordViewModel(useCase);
    });

    test('sendLink en éxito transita a success', () async {
      when(() => useCase(any()))
          .thenAnswer((_) async => const Result.success(null));

      await viewModel.sendLink('ana@example.com');

      expect(viewModel.state.status, AuthActionStatus.success);
    });

    test('sendLink en fallo expone el error', () async {
      when(() => useCase(any())).thenAnswer(
        (_) async => const Result.failure(ValidationException('Correo inválido')),
      );

      await viewModel.sendLink('bad');

      expect(viewModel.state.status, AuthActionStatus.error);
      expect(viewModel.state.errorMessage, 'Correo inválido');
    });
  });

  group('ResetPasswordViewModel', () {
    late MockResetPasswordUseCase useCase;
    late ResetPasswordViewModel viewModel;

    setUp(() {
      useCase = MockResetPasswordUseCase();
      viewModel = ResetPasswordViewModel(useCase);
    });

    test('submit en éxito transita a success', () async {
      when(() => useCase(
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),).thenAnswer((_) async => const Result.success(null));

      await viewModel.submit(code: 'c', newPassword: 'Abcdef1!');

      expect(viewModel.state.status, AuthActionStatus.success);
    });
  });
}
