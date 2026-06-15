import 'package:capitai/features/authentication/presentation/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

/// Fila con los botones de Google y Apple, usada en login y registro.
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    required this.onGoogle,
    required this.onApple,
    this.googleLoading = false,
    this.appleLoading = false,
    super.key,
  });

  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final bool googleLoading;
  final bool appleLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            label: 'Google',
            icon: const GoogleLogo(),
            isLoading: googleLoading,
            onPressed: onGoogle,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SocialLoginButton(
            label: 'Apple',
            icon: const Icon(Icons.apple, size: 22),
            isLoading: appleLoading,
            onPressed: onApple,
          ),
        ),
      ],
    );
  }
}
