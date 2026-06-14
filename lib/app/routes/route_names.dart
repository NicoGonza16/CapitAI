/// Nombres y rutas centralizadas de la aplicación.
///
/// Tener las rutas en un único lugar evita strings mágicos dispersos y facilita
/// el deep linking y los tests de navegación.
abstract final class RouteNames {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String products = 'products';
}

/// Paths asociados a cada ruta nombrada.
abstract final class RoutePaths {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String products = '/products';
}
