import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/widgets/gradient_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/pending_registration_provider.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/verify_account_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/signup_stepper.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/verification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de verificación de cuenta (paso 2): código OTP de 6 dígitos.
class VerifyAccountView extends ConsumerStatefulWidget {
  const VerifyAccountView({super.key});

  @override
  ConsumerState<VerifyAccountView> createState() => _VerifyAccountViewState();
}

class _VerifyAccountViewState extends ConsumerState<VerifyAccountView> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = ref.watch(pendingRegistrationProvider);

    // Sin registro pendiente (p. ej. recarga directa): volver al registro.
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.goNamed(RouteNames.register);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final email = user.email;
    final state = ref.watch(verifyAccountViewModelProvider(email));
    final notifier =
        ref.read(verifyAccountViewModelProvider(email).notifier);

    ref.listen<VerifyState>(verifyAccountViewModelProvider(email),
        (_, next) {
      if (next.status == VerifyStatus.success) {
        context.goNamed(RouteNames.accountVerified);
      } else if (next.status == VerifyStatus.error &&
          next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!);
      }
    });

    final codeComplete = _codeController.text.length == 6;

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
                      const Center(child: VerificationBadge()),
                      const SizedBox(height: 28),
                      Text(
                        l10n.verifyTitle,
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
                            TextSpan(text: l10n.verifySubtitle),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _OtpField(controller: _codeController),
                      const SizedBox(height: 20),
                      _ResendRow(
                        secondsRemaining: state.secondsRemaining,
                        canResend: state.canResend,
                        onResend: notifier.resend,
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        label: l10n.verifyButton,
                        isLoading: state.isLoading,
                        onPressed: codeComplete
                            ? () => notifier.verify(_codeController.text)
                            : null,
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
                onPressed: _onBack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Campo de código OTP de 6 dígitos (un único campo centrado y espaciado).
class _OtpField extends StatelessWidget {
  const _OtpField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 12,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        counterText: '',
        hintText: '••••••',
        hintStyle: TextStyle(letterSpacing: 12, fontSize: 28),
      ),
    );
  }
}

/// Texto/botón de reenvío con cuenta regresiva.
class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.secondsRemaining,
    required this.canResend,
    required this.onResend,
  });

  final int secondsRemaining;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (canResend) {
      return Center(
        child: TextButton(
          onPressed: onResend,
          child: Text(l10n.resendCode),
        ),
      );
    }
    final seconds = secondsRemaining.toString().padLeft(2, '0');
    return Center(
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: context.colors.onSurfaceVariant),
          children: [
            TextSpan(text: '${l10n.resendIn} '),
            TextSpan(
              text: '00:$seconds',
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
