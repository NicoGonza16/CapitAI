import 'package:enterprise_flutter_template/app/config/environment.dart';
import 'package:enterprise_flutter_template/bootstrap.dart';

/// Entrypoint del flavor de QA.
///
/// Ejecutar con: `flutter run --flavor qa -t lib/main_qa.dart`.
Future<void> main() => bootstrap(Flavor.qa);
