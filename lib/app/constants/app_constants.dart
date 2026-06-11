/// Constantes globales de la aplicación que no dependen del ambiente.
abstract final class AppConstants {
  /// Claves de almacenamiento persistente.
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';

  /// Reglas de validación.
  static const int minPasswordLength = 6;

  /// Endpoints relativos a la base URL.
  static const String loginEndpoint = '/auth/login';
  static const String refreshEndpoint = '/auth/refresh';
}
