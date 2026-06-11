import 'package:enterprise_flutter_template/app/config/environment.dart';
import 'package:enterprise_flutter_template/bootstrap.dart';

/// Entrypoint del flavor de desarrollo.
///
/// Ejecutar con: `flutter run --flavor dev -t lib/main_dev.dart`.
Future<void> main() => bootstrap(Flavor.dev);
