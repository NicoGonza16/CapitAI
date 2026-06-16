import 'package:capitai/app/routes/app_router.dart';
import 'package:capitai/app/themes/app_theme.dart';
import 'package:capitai/app/themes/theme_provider.dart';
import 'package:capitai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget raíz de la aplicación.
///
/// Conecta el router, los temas (claro/oscuro reactivos) y la
/// internacionalización. Todo el estado proviene de providers de Riverpod.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CapitAI',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
