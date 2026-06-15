// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CapitAI';

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
  String get passwordWeak => 'La contraseña no cumple los requisitos';

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
  String get verifyTitle => 'Verificar cuenta';

  @override
  String get verifySubtitle => 'Enviamos un código de 6 dígitos a';

  @override
  String get verifyButton => 'Verificar Cuenta';

  @override
  String get resendIn => 'Reenviar en';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get accountVerifiedTitle => '¡Cuenta verificada';

  @override
  String get accountVerifiedHighlight => 'exitosamente!';

  @override
  String get accountVerifiedSubtitle =>
      'Tu cuenta ha sido verificada correctamente. Ya puedes comenzar a gestionar tus finanzas con CapitAI.';

  @override
  String get accountVerifiedCardTitle => 'Cuenta verificada';

  @override
  String get accountVerifiedCardSubtitle =>
      'Tu información está segura y protegida';

  @override
  String get continueButton => 'Continuar';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo y te enviaremos un enlace seguro para restablecer tu contraseña.';

  @override
  String get secureLinkTitle => 'Enlace seguro';

  @override
  String get secureLinkSubtitle =>
      'El enlace expirará en 24 horas por tu seguridad.';

  @override
  String get sendRecoveryLink => 'Enviar Enlace de Recuperación';

  @override
  String get emailSentTitle => '¡Correo enviado!';

  @override
  String get emailSentSubtitle =>
      'Hemos enviado un enlace de recuperación a tu correo.';

  @override
  String get emailSentStep1 => 'Revisa tu bandeja de entrada';

  @override
  String get emailSentStep2 => 'Abre el correo de CapitAI';

  @override
  String get emailSentStep3 => 'Haz clic en el enlace de recuperación';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get newPasswordTitle => 'Nueva contraseña';

  @override
  String get newPasswordSubtitle =>
      'Crea una contraseña segura para proteger tu cuenta.';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get securityRequirementsTitle => 'Requisitos de seguridad';

  @override
  String get reqMinLength => 'Mínimo 8 caracteres';

  @override
  String get reqUppercase => 'Una letra mayúscula (A-Z)';

  @override
  String get reqNumber => 'Un número (0-9)';

  @override
  String get reqSpecial => 'Un carácter especial (!@#\$...)';

  @override
  String get updatePasswordButton => 'Actualizar Contraseña';

  @override
  String get passwordUpdatedTitle => '¡Contraseña actualizada';

  @override
  String get passwordUpdatedHighlight => 'con éxito!';

  @override
  String get passwordUpdatedSubtitle =>
      'Tu contraseña ha sido actualizada correctamente. Ya puedes iniciar sesión con tu nueva contraseña.';

  @override
  String get passwordUpdatedCardTitle => 'Contraseña segura';

  @override
  String get passwordUpdatedCardSubtitle =>
      'La contraseña fue actualizada correctamente y tu cuenta está protegida.';

  @override
  String get goToLogin => 'Ir al inicio de sesión';

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
