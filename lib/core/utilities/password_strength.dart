/// Evalúa los requisitos de seguridad de una contraseña.
///
/// Función pura y testeable usada tanto para validar como para mostrar la
/// lista de requisitos en vivo en la pantalla de nueva contraseña.
class PasswordStrength {
  const PasswordStrength({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasSpecial,
  });

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSpecial;

  /// `true` si cumple todos los requisitos.
  bool get isValid =>
      hasMinLength && hasUppercase && hasNumber && hasSpecial;

  /// Evalúa [password] contra los requisitos.
  factory PasswordStrength.of(String password) => PasswordStrength(
        hasMinLength: password.length >= 8,
        hasUppercase: password.contains(RegExp('[A-Z]')),
        hasNumber: password.contains(RegExp('[0-9]')),
        hasSpecial: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]')),
      );
}
