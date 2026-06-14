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
