import 'package:capitai/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Ilustración decorativa de la pantalla de bienvenida.
///
/// Representa una tarjeta de balance con "chips" flotantes (ingresos, gastos,
/// sugerencia de IA). Se dibuja sobre un lienzo de tamaño fijo ([_canvasWidth]
/// x [_canvasHeight]); la View la envuelve en un `FittedBox` para escalarla a
/// cualquier ancho disponible, garantizando responsividad sin recalcular
/// posiciones.
class BalanceCardPreview extends StatelessWidget {
  const BalanceCardPreview({super.key});

  static const double _canvasWidth = 330;
  static const double _canvasHeight = 300;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _canvasWidth,
      height: _canvasHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Halos decorativos de fondo.
          const Positioned(
            left: 8,
            top: 4,
            child: _Dot(color: AppColors.warning, size: 12),
          ),
          const Positioned(
            right: 0,
            top: 70,
            child: _Dot(color: AppColors.secondary, size: 10),
          ),

          // Tarjeta principal.
          Positioned(
            left: 20,
            top: 36,
            child: _MainCard(),
          ),

          // Chip: Ingresos (positivo).
          const Positioned(
            left: 0,
            top: 120,
            child: _StatChip(
              icon: Icons.trending_up,
              iconColor: AppColors.success,
              title: 'Ingresos',
              value: '+\$4,200',
              valueColor: AppColors.success,
            ),
          ),

          // Chip: Gastos (negativo).
          const Positioned(
            right: 0,
            top: 150,
            child: _StatChip(
              icon: Icons.trending_down,
              iconColor: AppColors.error,
              title: 'Gastos',
              value: '-\$1,830',
              valueColor: AppColors.error,
            ),
          ),

          // Chip: sugerencia de IA.
          const Positioned(
            left: 40,
            bottom: 6,
            child: _AiChip(),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta central con el balance total y un mini gráfico.
class _MainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance Total',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+ IA Activa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '\$24,580.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const _MiniChart(),
        ],
      ),
    );
  }
}

/// Mini gráfico de barras decorativo.
class _MiniChart extends StatelessWidget {
  const _MiniChart();

  @override
  Widget build(BuildContext context) {
    const heights = [22.0, 34.0, 18.0, 40.0, 28.0, 46.0, 32.0];
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final (i, h) in heights.indexed)
            Container(
              width: 18,
              height: h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: i == 5 ? 0.95 : 0.45),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip flotante blanco con icono, título y valor.
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return _FloatingSurface(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: iconColor.withValues(alpha: 0.15),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip de sugerencia de IA con avatar degradado.
class _AiChip extends StatelessWidget {
  const _AiChip();

  @override
  Widget build(BuildContext context) {
    return _FloatingSurface(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ahorra \$340 este mes',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                'reduciendo restaurantes',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Superficie blanca flotante reutilizable (sombra + borde redondeado).
class _FloatingSurface extends StatelessWidget {
  const _FloatingSurface({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Punto de color decorativo.
class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
