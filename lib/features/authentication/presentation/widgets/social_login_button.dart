import 'package:flutter/material.dart';

/// Botón de inicio de sesión con un proveedor social (Google, Apple).
///
/// Diseñado para usarse en una fila de dos. Muestra un spinner cuando
/// [isLoading] es `true` y deshabilita el resto mientras tanto.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10),
                Text(label),
              ],
            ),
    );
  }
}

/// Logo simplificado de Google (una "G" de color de marca).
///
/// En producción sustitúyelo por el asset oficial de Google (lineamientos de
/// marca exigen el logotipo correcto).
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({this.size = 20, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4285F4),
        height: 1,
      ),
    );
  }
}
