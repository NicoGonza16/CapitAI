import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/products/data/repositories/product_repository_provider.dart';
import 'package:capitai/features/products/domain/entities/product.dart';
import 'package:capitai/features/products/domain/repositories/product_repository.dart';
import 'package:capitai/shared/models/paginated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caso de uso: obtener una página del catálogo de productos.
class GetProductsUseCase {
  const GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  Future<Result<Paginated<Product>>> call({
    required int page,
    int pageSize = 20,
  }) =>
      _repository.fetchProducts(page: page, pageSize: pageSize);
}

/// Provider del caso de uso.
final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
  (ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)),
);
