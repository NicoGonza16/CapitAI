import 'package:enterprise_flutter_template/app/constants/app_constants.dart';
import 'package:enterprise_flutter_template/core/storage/key_value_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier que gestiona el [ThemeMode] y lo persiste localmente.
///
/// Ejemplo del uso de un [Notifier] de Riverpod para estado síncrono simple.
class ThemeNotifier extends Notifier<ThemeMode> {
  late final KeyValueStorage _storage;

  @override
  ThemeMode build() {
    _storage = ref.watch(keyValueStorageProvider);
    return _readPersisted();
  }

  ThemeMode _readPersisted() {
    final value = _storage.getString(AppConstants.keyThemeMode);
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  /// Cambia el modo de tema y lo persiste.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.setString(AppConstants.keyThemeMode, mode.name);
  }

  /// Alterna entre claro y oscuro.
  Future<void> toggle() => setThemeMode(
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );
}

/// Provider del modo de tema.
final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
