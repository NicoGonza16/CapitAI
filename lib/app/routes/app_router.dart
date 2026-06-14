import 'package:enterprise_flutter_template/app/routes/route_names.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/views/login_view.dart';
import 'package:enterprise_flutter_template/features/home/presentation/views/home_view.dart';
import 'package:enterprise_flutter_template/features/onboarding/presentation/views/welcome_view.dart';
import 'package:enterprise_flutter_template/features/products/presentation/views/products_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [Listenable] que reevalúa los guards de go_router cuando cambia la sesión.
class _RouterRefreshNotifier extends ChangeNotifier {
  /// Invocado por el provider cada vez que cambia el estado de autenticación.
  void refresh() => notifyListeners();
}

/// Provider del router de la aplicación con guards de autenticación.
///
/// Rutas centralizadas + deep linking (go_router resuelve URLs nativas) +
/// guard: usuarios no autenticados se redirigen a `/login`; autenticados que
/// visiten `/login` se envían al home. El router escucha el [AuthController] y
/// reevalúa el `redirect` automáticamente al cambiar la sesión.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier();
  ref.onDispose(refresh.dispose);

  // Cuando cambia el estado de sesión, forzamos la reevaluación de los guards.
  ref.listen<AsyncValue<User?>>(
    authControllerProvider,
    (_, __) => refresh.refresh(),
  );

  // Rutas accesibles sin sesión iniciada.
  const publicPaths = {RoutePaths.welcome, RoutePaths.login};

  return GoRouter(
    initialLocation: RoutePaths.welcome,
    refreshListenable: refresh,
    redirect: (context, state) {
      final isAuthenticated =
          ref.read(authControllerProvider).valueOrNull != null;
      final isPublic = publicPaths.contains(state.matchedLocation);

      // Sin sesión: solo se permiten rutas públicas; el resto va a welcome.
      if (!isAuthenticated) return isPublic ? null : RoutePaths.welcome;
      // Con sesión: si está en una ruta pública, se envía al home.
      if (isPublic) return RoutePaths.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.welcome,
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeView(),
        routes: [
          // Ruta anidada: /products. Hereda el guard de autenticación del padre.
          GoRoute(
            path: 'products',
            name: RouteNames.products,
            builder: (context, state) => const ProductsView(),
          ),
        ],
      ),
    ],
  );
});
