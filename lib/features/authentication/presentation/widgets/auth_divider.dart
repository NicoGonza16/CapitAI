import 'package:flutter/material.dart';

/// Separador con texto centrado ("o continúa con" / "o regístrate con").
class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant)),
      ],
    );
  }
}
