import 'package:enterprise_flutter_template/core/network/api_client.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/products/data/models/product_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fuente de datos remota del catálogo de productos.
abstract interface class ProductRemoteDataSource {
  /// Devuelve la lista de DTOs y si existe una página siguiente.
  Future<Result<({List<ProductDto> items, bool hasMore})>> fetchProducts({
    required int page,
    required int pageSize,
  });
}

/// Implementación HTTP de [ProductRemoteDataSource].
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._client);
  final ApiClient _client;

  @override
  Future<Result<({List<ProductDto> items, bool hasMore})>> fetchProducts({
    required int page,
    required int pageSize,
  }) async {
    final result = await _client.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    return result.map((response) {
      final data = response.data;
      final rawItems = (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
      return (
        items: rawItems.map(ProductDto.fromJson).toList(),
        hasMore: data['has_more'] as bool? ?? false,
      );
    });
  }
}

/// Provider de la fuente de datos remota.
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);
