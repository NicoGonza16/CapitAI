import 'package:enterprise_flutter_template/core/storage/token_storage.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:enterprise_flutter_template/features/authentication/data/services/fake_auth_service.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';
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
