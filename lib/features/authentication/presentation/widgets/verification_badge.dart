import 'package:enterprise_flutter_template/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Escudo con check usado en la pantalla de verificación (paso 2).
class VerificationBadge extends StatelessWidget {
  const VerificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Capa trasera tenue del escudo.
          Icon(
            Icons.shield,
            size: 120,
            color: AppColors.primaryLight.withValues(alpha: 0.7),
          ),
          // Escudo con degradado de marca.
          ShaderMask(
            shaderCallback: (bounds) => AppColors.cardGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: const Icon(Icons.shield, size: 96, color: Colors.white),
          ),
          const Icon(Icons.check, size: 40, color: Colors.white),
          // Puntos decorativos.
          const Positioned(
            left: 6,
            top: 40,
            child: _Dot(color: AppColors.tertiary),
          ),
          const Positioned(
            right: 8,
            top: 30,
            child: _Dot(color: AppColors.warning),
          ),
          const Positioned(
            right: 18,
            bottom: 24,
            child: _Dot(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}
