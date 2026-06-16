import 'package:capitai/app/config/environment.dart';
import 'package:capitai/bootstrap.dart';

/// Entrypoint del flavor de desarrollo.
///
/// Ejecutar con: `flutter run --flavor dev -t lib/main_dev.dart`.
Future<void> main() => bootstrap(Flavor.dev);
