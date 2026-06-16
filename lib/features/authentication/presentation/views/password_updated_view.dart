import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/app/themes/app_colors.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/core/widgets/gradient_button.dart';
import 'package:capitai/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:capitai/features/authentication/presentation/widgets/success_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "¡Contraseña actualizada con éxito!".
class PasswordUpdatedView extends ConsumerWidget {
  const PasswordUpdatedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Center(child: SuccessBadge()),
                      const SizedBox(height: 32),
                      _Title(
                        line1: l10n.passwordUpdatedTitle,
                        highlight: l10n.passwordUpdatedHighlight,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.passwordUpdatedSubtitle,
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SecurePasswordCard(),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: l10n.goToLogin,
                        trailingIcon: Icons.arrow_forward,
                        onPressed: () => context.goNamed(RouteNames.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 16,
              child: CircleIconButton(
                icon: Icons.arrow_back,
                onPressed: () => context.goNamed(RouteNames.login),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.line1, required this.highlight});
  final String line1;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
      height: 1.15,
    );
    return Column(
      children: [
        Text(line1, textAlign: TextAlign.center, style: style),
        ShaderMask(
          shaderCallback: (bounds) => AppColors.brandGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            highlight,
            textAlign: TextAlign.center,
            style: style?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta "Contraseña segura · cuenta protegida".
class _SecurePasswordCard extends StatelessWidget {
  const _SecurePasswordCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_outline, color: context.colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.passwordUpdatedCardTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.passwordUpdatedCardSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
