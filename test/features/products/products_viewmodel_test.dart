import 'package:capitai/core/exceptions/app_exception.dart';
import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/products/domain/entities/product.dart';
import 'package:capitai/features/products/domain/usecases/get_products_usecase.dart';
import 'package:capitai/features/products/presentation/viewmodels/products_viewmodel.dart';
import 'package:capitai/shared/models/paginated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockGetProductsUseCase useCase;

  Product product(int i) => Product(id: '$i', name: 'P$i', price: i.toDouble());

  Paginated<Product> page(int p, {required bool hasMore}) => Paginated(
        items: [product(p * 10), product(p * 10 + 1)],
        page: p,
        hasMore: hasMore,
      );

  /// Crea un contenedor con el caso de uso mockeado inyectado.
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        getProductsUseCaseProvider.overrideWithValue(useCase),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => useCase = MockGetProductsUseCase());

  test('build carga la primera página', () async {
    when(() => useCase(page: 1, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => Result.success(page(1, hasMore: true)));

    final container = makeContainer();
    final products = await container.read(productsViewModelProvider.future);

    expect(products, hasLength(2));
    expect(products.first.id, '10');
  });

  test('loadMore anexa la siguiente página a la lista existente', () async {
    when(() => useCase(page: 1, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => Result.success(page(1, hasMore: true)));
    when(() => useCase(page: 2, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => Result.success(page(2, hasMore: false)));

    final container = makeContainer();
    await container.read(productsViewModelProvider.future);

    await container.read(productsViewModelProvider.notifier).loadMore();

    final state = container.read(productsViewModelProvider);
    expect(state.requireValue, hasLength(4));
    expect(container.read(productsViewModelProvider.notifier).hasMore, isFalse);
  });

  test('loadMore no pide más páginas cuando hasMore es false', () async {
    when(() => useCase(page: 1, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => Result.success(page(1, hasMore: false)));

    final container = makeContainer();
    await container.read(productsViewModelProvider.future);

    await container.read(productsViewModelProvider.notifier).loadMore();

    verify(() => useCase(page: 1, pageSize: any(named: 'pageSize'))).called(1);
    verifyNever(() => useCase(page: 2, pageSize: any(named: 'pageSize')));
  });

  test('build propaga el error como AsyncError', () async {
    when(() => useCase(page: 1, pageSize: any(named: 'pageSize'))).thenAnswer(
      (_) async => const Result.failure(NetworkException('sin red')),
    );

    final container = makeContainer();

    await expectLater(
      container.read(productsViewModelProvider.future),
      throwsA(isA<NetworkException>()),
    );
  });
}
