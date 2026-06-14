// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Plantilla Empresarial';

  @override
  String get onboardingTitleLine1 => 'Tu dinero, impulsado por';

  @override
  String get onboardingTitleHighlight => 'inteligencia artificial';

  @override
  String get onboardingSubtitle =>
      'Controla tus gastos, recibe alertas inteligentes y mejora tus hábitos financieros.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get alreadyHaveAccount => 'Ya tengo cuenta';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginWelcomeBack => 'Bienvenido de vuelta';

  @override
  String get loginSecureConnection => 'Conexión segura SSL 256-bit';

  @override
  String get rememberMe => 'Recordarme';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get orContinueWith => 'o continúa con';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Únete a 256,000 usuarios inteligentes';

  @override
  String stepProgress(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameRequired => 'El nombre es obligatorio';

  @override
  String get passwordHintMin8 => 'Mínimo 8 caracteres';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Repite tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get acceptTermsPrefix => 'Acepto los ';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get termsConnector => ' y la ';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get mustAcceptTerms => 'Debes aceptar los términos para continuar';

  @override
  String get orSignUpWith => 'o regístrate con';

  @override
  String get haveAccount => '¿Ya tienes cuenta?';

  @override
  String get signIn => 'Inicia sesión';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get emailInvalid => 'Ingresa un correo válido';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginErrorGeneric =>
      'No fue posible iniciar sesión. Inténtalo de nuevo.';

  @override
  String get homeTitle => 'Inicio';

  @override
  String welcomeMessage(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get logoutButton => 'Cerrar sesión';
}
