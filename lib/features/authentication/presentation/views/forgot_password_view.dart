import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:enterprise_flutter_template/core/widgets/gradient_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/forgot_password_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/envelope_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "Recuperar contraseña": solicita el correo y envía el enlace.
class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(forgotPasswordViewModelProvider);
    final email = _emailController.text.trim();
    final canSend = Validators.isValidEmail(email);

    ref.listen<AuthActionState>(forgotPasswordViewModelProvider, (_, next) {
      if (next.status == AuthActionStatus.success) {
        ref.read(passwordResetEmailProvider.notifier).state = email;
        context.goNamed(RouteNames.passwordResetSent);
      } else if (next.status == AuthActionStatus.error &&
          next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!);
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
                      const Center(child: EnvelopeBadge()),
                      const SizedBox(height: 28),
                      Text(
                        l10n.forgotPasswordTitle,
                        style: context.textStyles.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.forgotPasswordSubtitle,
                        style:
                            TextStyle(color: context.colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        key: const Key('forgot_email_field'),
                        label: l10n.emailLabel,
                        hint: 'tu@correo.com',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (_) => null,
                      ),
                      const SizedBox(height: 16),
                      _SecureLinkCard(),
                      const SizedBox(height: 24),
                      GradientButton(
                        key: const Key('forgot_submit_button'),
                        label: l10n.sendRecoveryLink,
                        isLoading: state.isLoading,
                        onPressed: canSend
                            ? () => ref
                                .read(forgotPasswordViewModelProvider.notifier)
                                .sendLink(email)
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

/// Tarjeta informativa "Enlace seguro · expira en 24 horas".
class _SecureLinkCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: context.colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.secureLinkTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.secureLinkSubtitle,
                  style: TextStyle(
                    fontSize: 12,
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
