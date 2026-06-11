import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ambientes soportados por la aplicación.
enum Flavor { dev, qa, prod }

/// Configuración inmutable derivada del archivo `.env` cargado al arrancar.
///
/// Centraliza el acceso a variables sensibles para que ningún otro punto de la
/// app lea `dotenv` directamente. Esto facilita el mockeo en pruebas y evita
/// dependencias dispersas con la librería de configuración.
class Environment {
  /// Crea la configuración a partir de los valores ya cargados en [dotenv].
  Environment._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
  });

  /// Instancia global accesible tras llamar a [init].
  static late Environment current;

  final Flavor flavor;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;

  bool get isProduction => flavor == Flavor.prod;

  /// Carga el archivo `.env` correspondiente al [flavor] y materializa [current].
  ///
  /// Debe invocarse una sola vez en `main()` antes de `runApp`.
  static Future<void> init(Flavor flavor) async {
    final fileName = switch (flavor) {
      Flavor.dev => '.env.dev',
      Flavor.qa => '.env.qa',
      Flavor.prod => '.env.prod',
    };

    await dotenv.load(fileName: fileName);

    current = Environment._(
      flavor: flavor,
      apiBaseUrl: dotenv.get('API_BASE_URL'),
      connectTimeout: Duration(
        milliseconds: int.parse(dotenv.get('API_CONNECT_TIMEOUT_MS')),
      ),
      receiveTimeout: Duration(
        milliseconds: int.parse(dotenv.get('API_RECEIVE_TIMEOUT_MS')),
      ),
      enableLogging: dotenv.get('ENABLE_LOGGING') == 'true',
    );
  }

  /// Resuelve el [Flavor] desde `--dart-define=ENV=dev|qa|prod`.
  static Flavor flavorFromDartDefine() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return switch (env) {
      'prod' => Flavor.prod,
      'qa' => Flavor.qa,
      _ => Flavor.dev,
    };
  }
}
