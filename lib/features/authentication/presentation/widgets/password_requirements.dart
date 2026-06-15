import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/utilities/password_strength.dart';
import 'package:flutter/material.dart';

/// Tarjeta con los requisitos de seguridad de la contraseña.
///
/// Se marca en vivo según [strength]. Reutilizada en registro y en el
/// restablecimiento de contraseña.
class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({required this.strength, super.key});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: context.colors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.securityRequirementsTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Requirement(met: strength.hasMinLength, text: l10n.reqMinLength),
          _Requirement(met: strength.hasUppercase, text: l10n.reqUppercase),
          _Requirement(met: strength.hasNumber, text: l10n.reqNumber),
          _Requirement(met: strength.hasSpecial, text: l10n.reqSpecial),
        ],
      ),
    );
  }
}

/// Línea de requisito con check (cumplido) o círculo (pendiente).
class _Requirement extends StatelessWidget {
  const _Requirement({required this.met, required this.text});
  final bool met;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color =
        met ? context.semantic.success : context.colors.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
