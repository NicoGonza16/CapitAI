import 'package:enterprise_flutter_template/core/extensions/context_extensions.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_state.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/viewmodels/login_viewmodel.dart';
import 'package:enterprise_flutter_template/features/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla de inicio de sesión (View del patrón MVVM).
///
/// Es un [ConsumerWidget] "delgado": observa el [LoginState], reacciona a sus
/// cambios (errores, navegación) y delega toda la acción al ViewModel. No
/// contiene lógica de negocio.
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);

    // Efectos secundarios reactivos: mostrar errores. La navegación al home la
    // resuelve el router mediante el guard al cambiar el estado de sesión.
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.status == LoginStatus.error && next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.loginTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: LoginForm(
              isLoading: state.isLoading,
              onSubmit: (email, password) => ref
                  .read(loginViewModelProvider.notifier)
                  .login(email: email, password: password),
            ),
          ),
        ),
      ),
    );
  }
}
