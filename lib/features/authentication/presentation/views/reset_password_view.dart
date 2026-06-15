import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/utilities/password_strength.dart';
import 'package:enterprise_flutter_template/core/widgets/gradient_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_action_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/reset_password_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/lock_badge.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/password_requirements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "Nueva contraseña": restablece la contraseña tras el enlace.
class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
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
    final state = ref.watch(resetPasswordViewModelProvider);
    final password = _passwordController.text;
    final strength = PasswordStrength.of(password);
    final matches =
        password.isNotEmpty && password == _confirmController.text;
    final canSubmit = strength.isValid && matches;

    ref.listen<AuthActionState>(resetPasswordViewModelProvider, (_, next) {
      if (next.status == AuthActionStatus.success) {
        context.goNamed(RouteNames.passwordUpdated);
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
                      const LockBadge(),
                      const SizedBox(height: 20),
                      Text(
                        l10n.newPasswordTitle,
                        style: context.textStyles.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.newPasswordSubtitle,
                        style:
                            TextStyle(color: context.colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        key: const Key('reset_password_field'),
                        label: l10n.newPasswordLabel,
                        hint: l10n.passwordHintMin8,
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.newPassword],
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (_) => null,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        key: const Key('reset_confirm_field'),
                        label: l10n.confirmPasswordLabel,
                        hint: l10n.confirmPasswordHint,
                        icon: Icons.lock_outline,
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        validator: (_) => null,
                      ),
                      const SizedBox(height: 16),
                      PasswordRequirements(strength: strength),
                      const SizedBox(height: 24),
                      GradientButton(
                        key: const Key('reset_submit_button'),
                        label: l10n.updatePasswordButton,
                        isLoading: state.isLoading,
                        onPressed: canSubmit
                            ? () => ref
                                .read(resetPasswordViewModelProvider.notifier)
                                .submit(
                                  code: 'demo-oob-code',
                                  newPassword: password,
                                )
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
