import 'package:capitai/core/storage/secure_storage.dart';
import 'package:capitai/core/storage/token_storage.dart';
import 'package:capitai/features/authentication/data/services/auth_service.dart';
import 'package:capitai/features/authentication/domain/entities/user.dart';
import 'package:capitai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:capitai/features/authentication/domain/usecases/login_usecase.dart';
import 'package:capitai/features/authentication/domain/usecases/register_usecase.dart';
import 'package:capitai/features/authentication/domain/usecases/request_password_reset_usecase.dart';
import 'package:capitai/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:capitai/features/authentication/presentation/viewmodels/auth_controller.dart';
import 'package:capitai/features/products/data/datasource/product_remote_datasource.dart';
import 'package:capitai/features/products/domain/repositories/product_repository.dart';
import 'package:capitai/features/products/domain/usecases/get_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

/// Dobles de prueba (mocks) centralizados para reutilizar entre tests.
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockRequestPasswordResetUseCase extends Mock
    implements RequestPasswordResetUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockAuthController extends Mock implements AuthController {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

/// Valores de respaldo para los matchers `any()` de mocktail.
void registerCommonFallbacks() {
  registerFallbackValue(
    const User(id: '0', name: 'fallback', email: 'fallback@example.com'),
  );
}
