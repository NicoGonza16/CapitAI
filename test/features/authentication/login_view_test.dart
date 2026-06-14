import 'package:enterprise_flutter_template/app/themes/app_theme.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/views/login_view.dart';
import 'package:enterprise_flutter_template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase loginUseCase;
  late MockAuthRepository authRepository;
  late MockAuthController authController;

  const user = User(id: '1', name: 'Ada', email: 'ada@example.com');

  setUpAll(registerCommonFallbacks);

  setUp(() {
    loginUseCase = MockLoginUseCase();
    authRepository = MockAuthRepository();
    authController = MockAuthController();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        loginViewModelProvider.overrideWith(
          (ref) => LoginViewModel(
            loginUseCase: loginUseCase,
            authRepository: authRepository,
            authController: authController,
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: AppTheme.light,
        home: const LoginView(),
      ),
    );
  }

  testWidgets('renderiza email, password y botón de envío', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('muestra errores de validación al enviar vacío', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => loginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),);
  });

  testWidgets('invoca el caso de uso con credenciales válidas', (tester) async {
    when(() => loginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),).thenAnswer((_) async => const Result.success(user));

    await tester.pumpWidget(buildSubject());

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'ada@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      '123456',
    );
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pump();

    verify(() => loginUseCase(email: 'ada@example.com', password: '123456'))
        .called(1);
  });
}
