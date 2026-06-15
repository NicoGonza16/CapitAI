import 'package:enterprise_flutter_template/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Cuadrado redondeado con degradado y candado (cabecera de "Nueva contraseña").
class LockBadge extends StatelessWidget {
  const LockBadge({this.size = 56, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.lock, color: Colors.white, size: size * 0.5),
    );
  }
}
