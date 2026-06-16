import 'package:flutter/material.dart';

/// Indicador de páginas (puntos) para el carrusel de onboarding.
///
/// El punto activo se muestra como una "píldora" más ancha en color primario.
class PageDots extends StatelessWidget {
  const PageDots({
    required this.count,
    required this.activeIndex,
    super.key,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: i == activeIndex ? 24 : 8,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? colors.primary
                  : colors.primary.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
