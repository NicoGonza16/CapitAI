import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Punto único de inicialización de servicios clave al arrancar la app.
///
/// El splash observa este provider y, al completarse, decide la ruta inicial
/// (Home si hay sesión, Bienvenida si no). Aquí se irán añadiendo en el futuro
/// los servicios que deban estar listos antes de mostrar la UI principal:
/// Remote Config, analytics, notificaciones push, feature flags, etc.
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Espera a que el estado de sesión quede resuelto (Firebase restaura la
  // sesión de forma asíncrona al arrancar).
  await ref.watch(authControllerProvider.future);

  // TODO(servicios): inicializar aquí servicios clave adicionales, p. ej.:
  // await ref.watch(remoteConfigProvider.future);
  // await ref.watch(analyticsProvider).init();
  // await ref.watch(pushNotificationsProvider).init();
});
