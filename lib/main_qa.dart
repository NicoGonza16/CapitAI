import 'package:capitai/app/config/environment.dart';
import 'package:capitai/bootstrap.dart';

/// Entrypoint del flavor de QA.
///
/// Ejecutar con: `flutter run --flavor qa -t lib/main_qa.dart`.
Future<void> main() => bootstrap(Flavor.qa);
