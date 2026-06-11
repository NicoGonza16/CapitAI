import 'package:enterprise_flutter_template/app/config/environment.dart';
import 'package:enterprise_flutter_template/bootstrap.dart';

/// Entrypoint por defecto.
///
/// Resuelve el ambiente desde `--dart-define=ENV=dev|qa|prod`. Para builds con
/// flavors nativos usa en su lugar `lib/main_dev.dart`, `main_qa.dart` o
/// `main_prod.dart` con `flutter run --flavor <flavor> -t lib/main_<flavor>.dart`.
Future<void> main() => bootstrap(Environment.flavorFromDartDefine());
