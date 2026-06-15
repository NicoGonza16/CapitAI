import 'package:capitai/app/app.dart';
import 'package:capitai/app/config/environment.dart';
import 'package:capitai/core/storage/key_value_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Arranque compartido por todos los entrypoints de flavor.
///
/// Centraliza la inicialización (binding, ambiente, dependencias asíncronas)
/// para que `main_dev.dart`, `main_qa.dart` y `main_prod.dart` solo difieran en
/// el [Flavor] que inyectan. Evita duplicar la lógica de arranque.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Environment.init(flavor);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
