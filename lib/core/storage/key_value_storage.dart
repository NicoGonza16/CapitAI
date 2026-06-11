import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstracción para almacenamiento clave-valor NO sensible.
///
/// Permite cambiar la implementación (SharedPreferences, Hive, etc.) sin tocar
/// el resto de la app y facilita el mockeo en pruebas.
abstract interface class KeyValueStorage {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> remove(String key);
}

/// Implementación basada en [SharedPreferences].
class SharedPreferencesStorage implements KeyValueStorage {
  SharedPreferencesStorage(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// Inicializado en `main()` mediante `overrideWithValue`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Debe inicializarse en main() con override'),
);

/// Provider de la abstracción de almacenamiento clave-valor.
final keyValueStorageProvider = Provider<KeyValueStorage>(
  (ref) => SharedPreferencesStorage(ref.watch(sharedPreferencesProvider)),
);
