import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/app/themes/app_colors.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/core/preview/preview_app.dart';
import 'package:capitai/core/widgets/gradient_button.dart';
import 'package:capitai/features/onboarding/presentation/widgets/balance_card_preview.dart';
import 'package:capitai/features/onboarding/presentation/widgets/page_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:go_router/go_router.dart';

/// Preview de la pantalla de bienvenida para el Flutter Widget Preview.
@Preview(name: 'Welcome', size: Size(390, 844))
Widget welcomeViewPreview() => previewApp(const WelcomeView());

/// Pantalla de bienvenida / onboarding (primer punto del flujo de auth).
///
/// Es responsiva: el contenido se limita a un ancho máximo y se centra en
/// pantallas grandes; en alto se vuelve desplazable para no desbordar en
/// dispositivos cortos (p. ej. landscape). La ilustración se escala con
/// `FittedBox`, evitando recalcular posiciones.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  void _goToRegister(BuildContext context) =>
      context.goNamed(RouteNames.register);

  void _goToLogin(BuildContext context) =>
      context.goNamed(RouteNames.login);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Altura del hero proporcional a la pantalla, acotada para móvil/tablet.
    final heroHeight =
        (MediaQuery.sizeOf(context).height * 0.42).clamp(240.0, 380.0).toDouble();

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Limita el ancho para no estirar el contenido en tablet/desktop.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  // Ilustración hero escalada al ancho disponible con FittedBox.
                  SizedBox(
                    height: heroHeight,
                    child: const Center(
                      child: FittedBox(
                        child: BalanceCardPreview(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const PageDots(count: 3, activeIndex: 0),
                  const SizedBox(height: 28),
                  _Title(
                    line1: l10n.onboardingTitleLine1,
                    highlight: l10n.onboardingTitleHighlight,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.onboardingSubtitle,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    label: l10n.getStarted,
                    onPressed: () => _goToRegister(context),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => _goToLogin(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: context.colors.surface,
                    ),
                    child: Text(l10n.alreadyHaveAccount),
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

/// Título de dos líneas con la segunda resaltada en degradado de marca.
class _Title extends StatelessWidget {
  const _Title({required this.line1, required this.highlight});

  final String line1;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      height: 1.2,
    );

    return Column(
      children: [
        Text(line1, textAlign: TextAlign.center, style: style),
        // ShaderMask aplica el degradado de marca sobre el texto.
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
