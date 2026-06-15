import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/core/preview/preview_app.dart';
import 'package:capitai/core/utilities/password_strength.dart';
import 'package:capitai/core/utilities/validators.dart';
import 'package:capitai/core/widgets/gradient_button.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/pending_registration_provider.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/register_state.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/register_viewmodel.dart';
import 'package:capitai/features/authentication/presentation/widgets/auth_divider.dart';
import 'package:capitai/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:capitai/features/authentication/presentation/widgets/circle_icon_button.dart';
import 'package:capitai/features/authentication/presentation/widgets/password_requirements.dart';
import 'package:capitai/features/authentication/presentation/widgets/signup_stepper.dart';
import 'package:capitai/features/authentication/presentation/widgets/social_login_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Preview de la pantalla de registro para el Flutter Widget Preview.
@Preview(name: 'Register', size: Size(390, 844))
Widget registerViewPreview() => previewApp(const RegisterView());

/// Pantalla de creación de cuenta (paso 1 de 3 del onboarding).
///
/// View "delgada": gestiona estado de UI (controllers, mostrar contraseña) y
/// delega la lógica al [RegisterViewModel]. La navegación tras registrarse la
/// resuelve el router mediante el guard al cambiar la sesión.
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // Redibuja para desplegar/ocultar los requisitos al enfocar y para
    // marcarlos en vivo mientras se escribe.
    _passwordFocus.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final notifier = ref.read(registerViewModelProvider.notifier);
    if (!ref.read(registerViewModelProvider).acceptedTerms) {
      context.showSnackBar(context.l10n.mustAcceptTerms);
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      notifier.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
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
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);

    ref.listen<RegisterState>(registerViewModelProvider, (_, next) {
      if (next.status == LoginStatus.error && next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!);
      }
      // Registro por correo exitoso: guarda el usuario pendiente y pasa a la
      // verificación (paso 2). Los proveedores sociales entran directo (el guard
      // del router se encarga al autenticarse).
      if (next.status == LoginStatus.success &&
          next.activeMethod == AuthMethod.email &&
          next.user != null) {
        ref.read(pendingRegistrationProvider.notifier).state = next.user;
        context.goNamed(RouteNames.verify);
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
                        currentStep: 1,
                        totalSteps: 3,
                        label: l10n.stepProgress(1, 3),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.registerTitle,
                        style: context.textStyles.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.registerSubtitle,
                        style:
                            TextStyle(color: context.colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthTextField(
                              key: const Key('register_name_field'),
                              label: l10n.fullNameLabel,
                              hint: 'Ana García',
                              icon: Icons.person_outline,
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                              validator: (value) =>
                                  (value?.trim().isEmpty ?? true)
                                      ? l10n.fullNameRequired
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              key: const Key('register_email_field'),
                              label: l10n.emailLabel,
                              hint: 'ana@ejemplo.com',
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
                            const SizedBox(height: 16),
                            AuthTextField(
                              key: const Key('register_password_field'),
                              label: l10n.passwordLabel,
                              hint: l10n.passwordHintMin8,
                              icon: Icons.lock_outline,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.newPassword],
                              suffix: _EyeButton(
                                obscured: _obscurePassword,
                                onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              validator: (value) {
                                final v = value ?? '';
                                if (v.isEmpty) return l10n.passwordRequired;
                                if (!PasswordStrength.of(v).isValid) {
                                  return l10n.passwordWeak;
                                }
                                return null;
                              },
                            ),
                            // Requisitos: se despliegan al enfocar la contraseña.
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              alignment: Alignment.topCenter,
                              child: (_passwordFocus.hasFocus ||
                                      _passwordController.text.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: PasswordRequirements(
                                        strength: PasswordStrength.of(
                                          _passwordController.text,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(width: double.infinity),
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              key: const Key('register_confirm_field'),
                              label: l10n.confirmPasswordLabel,
                              hint: l10n.confirmPasswordHint,
                              icon: Icons.lock_outline,
                              controller: _confirmController,
                              obscureText: _obscureConfirm,
                              suffix: _EyeButton(
                                obscured: _obscureConfirm,
                                onTap: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                              ),
                              validator: (value) {
                                if ((value ?? '') != _passwordController.text) {
                                  return l10n.passwordsDoNotMatch;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _TermsAcceptance(
                        accepted: state.acceptedTerms,
                        onChanged: notifier.setAcceptedTerms,
                        onTapLink: () => context.showSnackBar(l10n.comingSoon),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        key: const Key('register_submit_button'),
                        label: l10n.createAccount,
                        isLoading: state.isLoadingMethod(AuthMethod.email),
                        onPressed: state.acceptedTerms ? _submit : null,
                      ),
                      const SizedBox(height: 20),
                      AuthDivider(text: l10n.orSignUpWith),
                      const SizedBox(height: 20),
                      SocialLoginRow(
                        googleLoading: state.isLoadingMethod(AuthMethod.google),
                        appleLoading: state.isLoadingMethod(AuthMethod.apple),
                        onGoogle: notifier.signInWithGoogle,
                        onApple: notifier.signInWithApple,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.haveAccount,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.colors.onSurfaceVariant,),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            onPressed: () => context.goNamed(RouteNames.login),
                            child: Text(l10n.signIn),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Botón de regreso fijo, siempre arriba a la izquierda.
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

/// Botón de ojo (mostrar/ocultar contraseña).
class _EyeButton extends StatelessWidget {
  const _EyeButton({required this.obscured, required this.onTap});
  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
      ),
    );
  }
}

/// Checkbox + texto con enlaces a Términos y Política de Privacidad.
class _TermsAcceptance extends StatefulWidget {
  const _TermsAcceptance({
    required this.accepted,
    required this.onChanged,
    required this.onTapLink,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTapLink;

  @override
  State<_TermsAcceptance> createState() => _TermsAcceptanceState();
}

class _TermsAcceptanceState extends State<_TermsAcceptance> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = widget.onTapLink;
    _privacyTap = TapGestureRecognizer()..onTap = widget.onTapLink;
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linkStyle = TextStyle(
      color: context.colors.primary,
      fontWeight: FontWeight.w600,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: widget.accepted,
            onChanged: (v) => widget.onChanged(v ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: context.colors.onSurface, height: 1.4),
                children: [
                  TextSpan(text: l10n.acceptTermsPrefix),
                  TextSpan(
                    text: l10n.termsAndConditions,
                    style: linkStyle,
                    recognizer: _termsTap,
                  ),
                  TextSpan(text: l10n.termsConnector),
                  TextSpan(
                    text: l10n.privacyPolicy,
                    style: linkStyle,
                    recognizer: _privacyTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
