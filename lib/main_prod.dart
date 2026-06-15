import 'package:capitai/app/config/environment.dart';
import 'package:capitai/bootstrap.dart';

/// Entrypoint del flavor de producción.
///
/// Ejecutar con: `flutter run --flavor prod -t lib/main_prod.dart`.
Future<void> main() => bootstrap(Flavor.prod);
