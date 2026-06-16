import 'package:capitai/features/authentication/data/repositories/auth_repository_provider.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controlador de la sesión global de autenticación.
///
/// Ejemplo de [AsyncNotifier]: el estado es el [User] de la sesión (o `null` si
/// no hay sesión). El router observa este provider para aplicar los guards de
/// autenticación de forma reactiva.
class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final result = await ref.watch(authRepositoryProvider).currentUser();
    return result.valueOrNull;
  }

  /// `true` si existe una sesión activa.
  bool get isAuthenticated => state.valueOrNull != null;

  /// Establece el usuario autenticado tras un login exitoso.
  void setAuthenticated(User user) => state = AsyncData(user);

  /// Cierra la sesión y limpia el estado.
  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

/// Provider del controlador de sesión.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);
