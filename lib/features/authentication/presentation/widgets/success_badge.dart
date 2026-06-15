import 'package:capitai/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Círculo de éxito con check y destellos (pantalla "Cuenta verificada").
class SuccessBadge extends StatelessWidget {
  const SuccessBadge({this.color, this.showSparkles = true, super.key});

  /// Color sólido del círculo. Si es `null`, usa el degradado de marca.
  final Color? color;

  /// Muestra los destellos decorativos alrededor del círculo.
  final bool showSparkles;

  @override
  Widget build(BuildContext context) {
    final solid = color;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anillo tenue exterior.
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Container(
            width: 145,
            height: 145,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withValues(alpha: 0.5),
            ),
          ),
          // Círculo principal con degradado.
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              gradient: solid == null ? AppColors.cardGradient : null,
              color: solid,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (solid ?? AppColors.primary).withValues(alpha: 0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(Icons.check, size: 60, color: Colors.white),
          ),
          // Destellos.
          if (showSparkles) ...[
            const Positioned(
              left: 18,
              top: 50,
              child: Icon(Icons.auto_awesome,
                  size: 16, color: AppColors.secondary,),
            ),
            const Positioned(
              right: 22,
              top: 40,
              child: Icon(Icons.star, size: 14, color: AppColors.tertiary),
            ),
            const Positioned(
              left: 40,
              bottom: 26,
              child: Icon(Icons.auto_awesome,
                  size: 14, color: AppColors.success,),
            ),
            const Positioned(
              right: 34,
              bottom: 30,
              child: Icon(Icons.circle, size: 9, color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }
}
