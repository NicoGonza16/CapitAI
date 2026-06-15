import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/widgets/gradient_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/forgot_password_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/success_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "¡Correo enviado!": confirma el envío del enlace de recuperación.
class EmailSentView extends ConsumerWidget {
  const EmailSentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final email = ref.watch(passwordResetEmailProvider) ?? '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: SuccessBadge(
                      color: context.semantic.success,
                      showSparkles: false,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.emailSentTitle,
                    textAlign: TextAlign.center,
                    style: context.textStyles.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.emailSentSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (email.isNotEmpty) _EmailChip(email: email),
                  const SizedBox(height: 24),
                  _StepTile(number: 1, text: l10n.emailSentStep1),
                  const SizedBox(height: 10),
                  _StepTile(number: 2, text: l10n.emailSentStep2),
                  const SizedBox(height: 10),
                  // El 3º simula abrir el enlace del correo (deep link).
                  _StepTile(
                    number: 3,
                    text: l10n.emailSentStep3,
                    onTap: () => context.goNamed(RouteNames.resetPassword),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: l10n.backToLogin,
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip con el correo destinatario.
class _EmailChip extends StatelessWidget {
  const _EmailChip({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mail_outline,
                size: 18, color: context.colors.primary,),
            const SizedBox(width: 8),
            Text(email, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Paso numerado en tarjeta blanca.
class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.text, this.onTap});
  final int number;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
              if (onTap != null)
                Icon(Icons.chevron_right,
                    color: context.colors.onSurfaceVariant,),
            ],
          ),
        ),
      ),
    );
  }
}
