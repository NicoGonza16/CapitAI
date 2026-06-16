import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/app/themes/app_colors.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/core/widgets/gradient_button.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/pending_registration_provider.dart';
import 'package:capitai/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:capitai/features/authentication/presentation/widgets/signup_stepper.dart';
import 'package:capitai/features/authentication/presentation/widgets/success_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de cuenta verificada (paso 3). Al continuar, inicia la sesión.
class AccountVerifiedView extends ConsumerWidget {
  const AccountVerifiedView({super.key});

  void _onContinue(WidgetRef ref, BuildContext context) {
    final user = ref.read(pendingRegistrationProvider);
    ref.read(pendingRegistrationProvider.notifier).state = null;
    if (user != null) {
      // Inicia la sesión: el guard del router redirige al Home.
      ref.read(authControllerProvider.notifier).setAuthenticated(user);
    } else {
      context.goNamed(RouteNames.login);
    }
  }

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
                      SignupStepper(
                        currentStep: 3,
                        totalSteps: 3,
                        label: l10n.stepProgress(3, 3),
                      ),
                      const SizedBox(height: 24),
                      const Center(child: SuccessBadge()),
                      const SizedBox(height: 32),
                      _Title(
                        line1: l10n.accountVerifiedTitle,
                        highlight: l10n.accountVerifiedHighlight,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.accountVerifiedSubtitle,
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SecureInfoCard(),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: l10n.continueButton,
                        trailingIcon: Icons.arrow_forward,
                        onPressed: () => _onContinue(ref, context),
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
                onPressed: () => context.goNamed(RouteNames.welcome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Título de dos líneas con la segunda resaltada en degradado.
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

/// Tarjeta "Cuenta verificada · Tu información está segura y protegida".
class _SecureInfoCard extends StatelessWidget {
  const _SecureInfoCard();

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
              color: context.semantic.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: context.semantic.success,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountVerifiedCardTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.accountVerifiedCardSubtitle,
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
