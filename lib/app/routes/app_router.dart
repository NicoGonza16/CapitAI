import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:capitai/features/authentication/presentation/views/account_verified_view.dart';
import 'package:capitai/features/authentication/presentation/views/email_sent_view.dart';
import 'package:capitai/features/authentication/presentation/views/forgot_password_view.dart';
import 'package:capitai/features/authentication/presentation/views/login_view.dart';
import 'package:capitai/features/authentication/presentation/views/password_updated_view.dart';
import 'package:capitai/features/authentication/presentation/views/register_view.dart';
import 'package:capitai/features/authentication/presentation/views/reset_password_view.dart';
import 'package:capitai/features/authentication/presentation/views/verify_email_view.dart';
import 'package:capitai/features/home/presentation/views/home_view.dart';
import 'package:capitai/features/onboarding/presentation/views/splash_view.dart';
import 'package:capitai/features/onboarding/presentation/views/welcome_view.dart';
import 'package:capitai/features/products/presentation/views/products_view.dart';
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
  const publicPaths = {
    RoutePaths.welcome,
    RoutePaths.login,
    RoutePaths.register,
    RoutePaths.verify,
    RoutePaths.accountVerified,
    RoutePaths.forgotPassword,
    RoutePaths.passwordResetSent,
    RoutePaths.resetPassword,
    RoutePaths.passwordUpdated,
  };

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      // El splash gestiona su propia navegación tras inicializar servicios.
      if (state.matchedLocation == RoutePaths.splash) return null;

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
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashView(),
      ),
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
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: RoutePaths.verify,
        name: RouteNames.verify,
        builder: (context, state) => const VerifyEmailView(),
      ),
      GoRoute(
        path: RoutePaths.accountVerified,
        name: RouteNames.accountVerified,
        builder: (context, state) => const AccountVerifiedView(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: RoutePaths.passwordResetSent,
        name: RouteNames.passwordResetSent,
        builder: (context, state) => const EmailSentView(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: RoutePaths.passwordUpdated,
        name: RouteNames.passwordUpdated,
        builder: (context, state) => const PasswordUpdatedView(),
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
