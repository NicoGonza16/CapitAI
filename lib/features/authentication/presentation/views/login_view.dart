import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/app/themes/app_colors.dart';
import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:enterprise_flutter_template/core/widgets/gradient_button.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de inicio de sesión (View del patrón MVVM).
///
/// Es una View "delgada": gestiona solo estado de UI (controllers, mostrar
/// contraseña) y delega toda la lógica al [LoginViewModel]. La navegación tras
/// autenticarse la resuelve el router mediante el guard al cambiar la sesión.
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitEmail() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginViewModelProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);

    // Muestra los errores de autenticación como SnackBar.
    ref.listen<LoginState>(loginViewModelProvider, (_, next) {
      if (next.status == LoginStatus.error && next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _CircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: _onBack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _WelcomeHeaderCard(),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          key: const Key('login_email_field'),
                          label: l10n.emailLabel,
                          hint: 'hola@ejemplo.com',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return l10n.emailRequired;
                            if (!Validators.isValidEmail(v)) {
                              return l10n.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          key: const Key('login_password_field'),
                          label: l10n.passwordLabel,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: _obscure,
                          autofillHints: const [AutofillHints.password],
                          suffix: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (value) {
                            final v = value ?? '';
                            if (v.isEmpty) return l10n.passwordRequired;
                            if (!Validators.isValidPassword(v)) {
                              return l10n.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _RememberAndForgot(
                    rememberMe: state.rememberMe,
                    onRememberChanged: notifier.setRememberMe,
                    onForgot: () => context.showSnackBar(l10n.comingSoon),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    key: const Key('login_submit_button'),
                    label: l10n.loginButton,
                    isLoading: state.isLoadingMethod(AuthMethod.email),
                    onPressed: _submitEmail,
                  ),
                  const SizedBox(height: 20),
                  _OrDivider(text: l10n.orContinueWith),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SocialLoginButton(
                          label: 'Google',
                          icon: const GoogleLogo(),
                          isLoading: state.isLoadingMethod(AuthMethod.google),
                          onPressed: notifier.signInWithGoogle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SocialLoginButton(
                          label: 'Apple',
                          icon: const Icon(Icons.apple, size: 22),
                          isLoading: state.isLoadingMethod(AuthMethod.apple),
                          onPressed: notifier.signInWithApple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _CreateAccountRow(
                    question: l10n.noAccount,
                    action: l10n.createAccount,
                    onTap: () => context.showSnackBar(l10n.comingSoon),
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

/// Botón circular (flecha de regreso).
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

/// Tarjeta de cabecera: "Bienvenido de vuelta" + conexión segura.
class _WelcomeHeaderCard extends StatelessWidget {
  const _WelcomeHeaderCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.show_chart, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.loginWelcomeBack,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.loginSecureConnection,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.shield_outlined, color: context.semantic.success, size: 20),
        ],
      ),
    );
  }
}

/// Fila "Recordarme" + "¿Olvidaste tu contraseña?".
class _RememberAndForgot extends StatelessWidget {
  const _RememberAndForgot({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgot,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: InkWell(
            onTap: () => onRememberChanged(!rememberMe),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: rememberMe,
                    onChanged: (v) => onRememberChanged(v ?? false),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(l10n.rememberMe, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            onPressed: onForgot,
            child: Text(l10n.forgotPassword, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

/// Separador "o continúa con".
class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}

/// Fila "¿No tienes cuenta? Crear cuenta".
class _CreateAccountRow extends StatelessWidget {
  const _CreateAccountRow({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            question,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          onPressed: onTap,
          child: Text(action),
        ),
      ],
    );
  }
}
