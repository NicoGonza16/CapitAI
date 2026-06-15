import 'package:capitai/app/themes/app_colors.dart';
import 'package:capitai/app/themes/app_semantic_colors.dart';
import 'package:flutter/material.dart';

/// Definición centralizada de los temas claro y oscuro (Material 3).
///
/// El [ColorScheme] se genera con `ColorScheme.fromSeed` (que produce una
/// paleta tonal armónica y accesible) y luego se anclan los colores exactos de
/// marca (`primary`, `secondary`, `tertiary`, `error`). Los colores semánticos
/// extra se inyectan vía [AppSemanticColors] como `ThemeExtension`.
abstract final class AppTheme {
  /// Tema para modo claro.
  static ThemeData get light => _build(Brightness.light);

  /// Tema para modo oscuro.
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
    );

    final base = ThemeData(useMaterial3: true, brightness: brightness);

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      extensions: <ThemeExtension<dynamic>>[
        isLight ? AppSemanticColors.light : AppSemanticColors.dark,
      ],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? Colors.white : scheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
