import 'package:capitai/features/authentication/presentation/viewmodels/verify_account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockVerificationService service;
  late VerifyAccountViewModel viewModel;

  setUp(() {
    service = MockVerificationService();
    when(() => service.sendCode(any())).thenAnswer((_) async {});
    viewModel = VerifyAccountViewModel(
      service: service,
      email: 'ana@example.com',
    );
  });

  tearDown(() => viewModel.dispose());

  test('inicia la cuenta regresiva y envía el código', () {
    expect(viewModel.state.secondsRemaining, greaterThan(0));
    verify(() => service.sendCode('ana@example.com')).called(1);
  });

  test('verify con código válido transita a success', () async {
    when(() => service.verifyCode(
          email: any(named: 'email'),
          code: any(named: 'code'),
        ),).thenAnswer((_) async => true);

    await viewModel.verify('123456');

    expect(viewModel.state.status, VerifyStatus.success);
  });

  test('verify con código inválido transita a error', () async {
    when(() => service.verifyCode(
          email: any(named: 'email'),
          code: any(named: 'code'),
        ),).thenAnswer((_) async => false);

    await viewModel.verify('000');

    expect(viewModel.state.status, VerifyStatus.error);
    expect(viewModel.state.errorMessage, isNotNull);
  });
}
