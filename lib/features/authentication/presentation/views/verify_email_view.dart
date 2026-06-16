import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/core/widgets/gradient_button.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/pending_registration_provider.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/verify_email_viewmodel.dart';
import 'package:capitai/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:capitai/features/authentication/presentation/widgets/envelope_badge.dart';
import 'package:capitai/features/authentication/presentation/widgets/signup_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "Verifica tu correo" (paso 2): enlace de verificación de Firebase.
class VerifyEmailView extends ConsumerWidget {
  const VerifyEmailView({super.key});

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.register);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(pendingRegistrationProvider);

    // Sin registro pendiente (p. ej. recarga directa): volver al registro.
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.goNamed(RouteNames.register);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final state = ref.watch(verifyEmailViewModelProvider);
    final notifier = ref.read(verifyEmailViewModelProvider.notifier);

    ref.listen<AuthActionState>(verifyEmailViewModelProvider, (_, next) {
      if (next.status == AuthActionStatus.success) {
        context.goNamed(RouteNames.accountVerified);
      } else if (next.status == AuthActionStatus.error) {
        final message = next.errorMessage == 'not-verified'
            ? l10n.emailNotVerifiedYet
            : (next.errorMessage ?? l10n.emailNotVerifiedYet);
        context.showSnackBar(message);
      }
    });

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
                        currentStep: 2,
                        totalSteps: 3,
                        label: l10n.stepProgress(2, 3),
                      ),
                      const SizedBox(height: 24),
                      const Center(child: EnvelopeBadge()),
                      const SizedBox(height: 28),
                      Text(
                        l10n.verifyEmailTitle,
                        style: context.textStyles.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: context.colors.onSurfaceVariant,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: '${l10n.verifyEmailSubtitle} '),
                            TextSpan(
                              text: user.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      GradientButton(
                        label: l10n.alreadyVerified,
                        isLoading: state.isLoading,
                        onPressed: notifier.checkVerified,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          await notifier.sendLink();
                          if (context.mounted) {
                            context.showSnackBar(l10n.verificationLinkSent);
                          }
                        },
                        child: Text(l10n.resendLink),
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
                onPressed: () => _onBack(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
