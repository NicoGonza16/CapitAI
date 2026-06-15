import 'package:enterprise_flutter_template/app/themes/app_theme.dart';
import 'package:enterprise_flutter_template/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Envuelve una pantalla para mostrarla en el Flutter Widget Preview.
///
/// Proporciona el [ProviderScope] (Riverpod), el tema de marca y las
/// localizaciones, igual que la app real, para que los `@Preview` rendericen
/// con el aspecto definitivo. Úsalo desde funciones anotadas con `@Preview`.
Widget previewApp(Widget child, {Brightness brightness = Brightness.light}) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode:
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      home: child,
    ),
  );
}
