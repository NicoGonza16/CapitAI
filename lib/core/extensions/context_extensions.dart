import 'package:enterprise_flutter_template/app/themes/app_semantic_colors.dart';
import 'package:enterprise_flutter_template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Atajos sobre [BuildContext] para reducir verbosidad en las Views.
extension BuildContextX on BuildContext {
  /// Acceso al tema actual.
  ThemeData get theme => Theme.of(this);

  /// Acceso a la paleta de colores.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Acceso a la tipografía.
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Acceso a los colores semánticos (success, warning, info).
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>()!;

  /// Acceso a las cadenas localizadas.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Muestra un SnackBar con un mensaje breve.
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
