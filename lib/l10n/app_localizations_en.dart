// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Enterprise Template';

  @override
  String get onboardingTitleLine1 => 'Your money, powered by';

  @override
  String get onboardingTitleHighlight => 'artificial intelligence';

  @override
  String get onboardingSubtitle =>
      'Track your spending, get smart alerts and improve your financial habits.';

  @override
  String get getStarted => 'Get started';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSecureConnection => '256-bit SSL secure connection';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create account';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Join 256,000 smart users';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameRequired => 'Name is required';

  @override
  String get passwordHintMin8 => 'At least 8 characters';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Repeat your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get acceptTermsPrefix => 'I accept the ';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get termsConnector => ' and the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get mustAcceptTerms => 'You must accept the terms to continue';

  @override
  String get orSignUpWith => 'or sign up with';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginErrorGeneric => 'Unable to sign in. Please try again.';

  @override
  String get homeTitle => 'Home';

  @override
  String welcomeMessage(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get logoutButton => 'Sign out';
}
