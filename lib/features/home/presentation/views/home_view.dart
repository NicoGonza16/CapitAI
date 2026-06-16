import 'package:capitai/app/routes/route_names.dart';
import 'package:capitai/app/themes/theme_provider.dart';
import 'package:capitai/core/extensions/context_extensions.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla principal tras iniciar sesión.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            tooltip: 'Theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            tooltip: context.l10n.logoutButton,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.welcomeMessage(user?.name ?? '—'),
              style: context.textStyles.headlineSmall,
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Products'),
              onPressed: () => context.goNamed(RouteNames.products),
            ),
          ],
        ),
      ),
    );
  }
}
