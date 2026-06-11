import 'package:flutter/material.dart';

/// Definición centralizada de los temas claro y oscuro.
///
/// Se basa en Material 3 con un color semilla, de modo que toda la paleta se
/// deriva de forma consistente. Mantener los temas aquí evita estilos mágicos
/// dispersos por los widgets.
abstract final class AppTheme {
  static const Color _seed = Color(0xFF2962FF);

  /// Tema para modo claro.
  static ThemeData get light => _base(Brightness.light);

  /// Tema para modo oscuro.
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }
}
