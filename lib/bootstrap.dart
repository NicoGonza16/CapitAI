import 'package:capitai/app/app.dart';
import 'package:capitai/app/config/environment.dart';
import 'package:capitai/core/storage/key_value_storage.dart';
import 'package:capitai/features/authentication/data/services/auth_service.dart';
import 'package:capitai/features/authentication/data/services/fake_auth_service.dart';
import 'package:capitai/features/authentication/data/services/firebase_auth_service.dart';
import 'package:capitai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final authService = await _initAuthService();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authServiceProvider.overrideWithValue(authService),
      ],
      child: const App(),
    ),
  );
}

/// Inicializa Firebase y devuelve el [AuthService] real.
///
/// Si Firebase no está configurado correctamente, cae a [FakeAuthService] para
/// que la app siga ejecutándose (útil en desarrollo / pruebas de UI).
Future<AuthService> _initAuthService() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseAuthService();
  } catch (e, st) {
    debugPrint('Firebase no inicializado, usando FakeAuthService: $e\n$st');
    return FakeAuthService();
  }
}
