import 'package:capitai/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Ilustración de sobre con lupa para "Recuperar contraseña" (paso 1).
class EnvelopeBadge extends StatelessWidget {
  const EnvelopeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          // Sobre con degradado.
          ShaderMask(
            shaderCallback: (bounds) => AppColors.cardGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: const Icon(Icons.email, size: 84, color: Colors.white),
          ),
          // Insignia de búsqueda.
          Positioned(
            top: 14,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
