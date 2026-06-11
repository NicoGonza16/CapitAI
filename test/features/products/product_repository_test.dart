import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/products/data/models/product_dto.dart';
import 'package:enterprise_flutter_template/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockProductRemoteDataSource remote;
  late ProductRepositoryImpl repository;

  setUp(() {
    remote = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(remote);
  });

  test('mapea los DTOs a entidades y construye Paginated', () async {
    when(() => remote.fetchProducts(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer(
      (_) async => Result.success((
        items: const [ProductDto(id: '1', name: 'Lápiz', price: 9.5)],
        hasMore: true,
      )),
    );

    final result = await repository.fetchProducts(page: 1);

    final value = result.valueOrNull;
    expect(value, isNotNull);
    expect(value!.items.single.name, 'Lápiz');
    expect(value.page, 1);
    expect(value.hasMore, isTrue);
  });
}
