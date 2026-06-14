import 'package:flutter/material.dart';

/// Paleta de marca cruda (design tokens).
///
/// Define los colores base de la identidad visual. El [ColorScheme] de Material
/// se deriva de estos valores; los widgets nunca deben usar estos colores
/// directamente salvo para gradientes decorativos (no cubiertos por el scheme).
abstract final class AppColors {
  // --- Marca ---------------------------------------------------------------
  /// Color principal de la marca.
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFEDE9FE);

  /// Secundario (índigo) — armoniza con el degradado de marca.
  static const Color secondary = Color(0xFF6366F1);

  /// Terciario (cian) — color de acento para destacar.
  static const Color tertiary = Color(0xFF06B6D4);

  // --- Semánticos ----------------------------------------------------------
  static const Color success = Color(0xFF10B981); // Ingresos / positivo
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color error = Color(0xFFEF4444); // Gastos / negativo

  // --- Neutros -------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF8F7FC);
  static const Color darkBackground = Color(0xFF12101A);

  // --- Gradientes ----------------------------------------------------------
  /// Degradado horizontal usado en CTAs y textos destacados.
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
  );

  /// Degradado diagonal usado en tarjetas (balance).
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
