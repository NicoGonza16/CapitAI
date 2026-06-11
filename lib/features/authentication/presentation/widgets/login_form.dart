import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:enterprise_flutter_template/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Formulario de login reutilizable y sin lógica de negocio.
///
/// Solo valida formato de entrada y delega el envío mediante [onSubmit]. No
/// conoce repositorios ni el ViewModel directamente: recibe todo por parámetros
/// (inversión de control), lo que lo hace fácil de testear de forma aislada.
class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onSubmit,
    required this.isLoading,
    super.key,
  });

  final void Function(String email, String password) onSubmit;
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            key: const Key('login_email_field'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: l10n.emailLabel),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return l10n.emailRequired;
              if (!Validators.isValidEmail(v)) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('login_password_field'),
            controller: _passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(labelText: l10n.passwordLabel),
            validator: (value) {
              final v = value ?? '';
              if (v.isEmpty) return l10n.passwordRequired;
              if (!Validators.isValidPassword(v)) return l10n.passwordTooShort;
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('login_submit_button'),
            label: l10n.loginButton,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
