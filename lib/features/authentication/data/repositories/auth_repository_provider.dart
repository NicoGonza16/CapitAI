import 'package:enterprise_flutter_template/core/storage/token_storage.dart';
import 'package:enterprise_flutter_template/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:enterprise_flutter_template/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:enterprise_flutter_template/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que expone la implementación de [AuthRepository].
///
/// La inyección de dependencias se realiza íntegramente con Riverpod: este
/// provider compone el datasource y el almacenamiento de tokens. No se usa un
/// Service Locator global.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
