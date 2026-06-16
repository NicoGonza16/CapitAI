import 'package:capitai/core/storage/token_storage.dart';
import 'package:capitai/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:capitai/features/authentication/data/services/fake_auth_service.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que expone la implementación de [AuthRepository].
///
/// La inyección de dependencias se realiza íntegramente con Riverpod: compone el
/// [AuthService] (Firebase / fake) y el almacenamiento de tokens. No se usa un
/// Service Locator global.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    authService: ref.watch(authServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
