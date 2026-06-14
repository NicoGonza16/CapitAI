import 'package:enterprise_flutter_template/app/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Colores semánticos extra que Material no cubre (success, warning, info).
///
/// Se exponen como [ThemeExtension] para que sean *theme-aware* (cambian con
/// claro/oscuro) y accesibles de forma type-safe vía
/// `Theme.of(context).extension<AppSemanticColors>()`. Es la forma recomendada
/// por Material 3 para añadir colores fuera del [ColorScheme].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.info,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color info;

  /// Variante para modo claro.
  static const AppSemanticColors light = AppSemanticColors(
    success: AppColors.success,
    onSuccess: Colors.white,
    warning: AppColors.warning,
    info: AppColors.info,
  );

  /// Variante para modo oscuro (tonos algo más luminosos).
  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF34D399),
    onSuccess: Color(0xFF06281D),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF60A5FA),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? info,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
