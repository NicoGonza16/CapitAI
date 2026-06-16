import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/app/startup/app_initializer.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de carga inicial (splash).
///
/// Mientras se inicializan los servicios clave ([appInitializationProvider])
/// muestra la marca, y al terminar enruta a Home (con sesión) o Bienvenida.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  /// Duración mínima del splash para evitar un parpadeo.
  static const _minDuration = Duration(milliseconds: 1800);

  @override
  void initState() {
    super.initState();
    _bootstrapAndRoute();
  }

  Future<void> _bootstrapAndRoute() async {
    try {
      await Future.wait([
        ref.read(appInitializationProvider.future),
        Future<void>.delayed(_minDuration),
      ]);
    } catch (_) {
      // Si la inicialización falla, igual continuamos al flujo público.
    }
    if (!mounted) return;
    final isAuthenticated =
        ref.read(authControllerProvider).valueOrNull != null;
    context.goNamed(
      isAuthenticated ? RouteNames.home : RouteNames.welcome,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SplashBackground(child: _SplashContent()),
    );
  }
}

/// Fondo con degradado de marca a pantalla completa.
class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6), Color(0xFF4F46E5)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        // Chips decorativos flotantes.
        const Positioned(
          left: 20,
          top: 24,
          child: _GlassChip(
            child: _LabeledValue(label: 'Ahorro mensual', value: '+\$1,240'),
          ),
        ),
        const Positioned(
          right: 20,
          top: 60,
          child: _GlassChip(child: Text('↗ +12%', style: _chipTextStyle)),
        ),
        const Positioned(
          right: 24,
          bottom: 150,
          child: _GlassChip(
            background: Color(0x33F59E0B),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_active,
                    color: Color(0xFFFBBF24), size: 16,),
                SizedBox(width: 6),
                Text('Alerta IA', style: _chipTextStyle),
              ],
            ),
          ),
        ),

        // Bloque central de marca.
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(Icons.show_chart,
                    color: Colors.white, size: 48,),
              ),
              const SizedBox(height: 28),
              const Text(
                'CapitAI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.splashTagline.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatChip(value: 'IA', label: 'Predictiva'),
                  SizedBox(width: 12),
                  _StatChip(value: '256K', label: 'Usuarios'),
                  SizedBox(width: 12),
                  _StatChip(value: '99.2%', label: 'Precisión'),
                ],
              ),
            ],
          ),
        ),

        // Indicador de carga inferior.
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Column(
            children: [
              SizedBox(
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.splashLoading,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _chipTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w600,
);

/// Contenedor "glass" reutilizado por los chips flotantes.
class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.child, this.background});
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background ?? Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}

/// Etiqueta pequeña sobre valor en negrita (chip "Ahorro mensual").
class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
        Text(value, style: _chipTextStyle),
      ],
    );
  }
}

/// Chip de estadística (valor grande + etiqueta) del bloque central.
class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
