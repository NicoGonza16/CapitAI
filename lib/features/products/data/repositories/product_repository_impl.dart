import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/products/data/datasource/product_remote_datasource.dart';
import 'package:enterprise_flutter_template/features/products/domain/entities/product.dart';
import 'package:enterprise_flutter_template/features/products/domain/repositories/product_repository.dart';
import 'package:enterprise_flutter_template/shared/models/paginated.dart';

/// Implementación del [ProductRepository].
///
/// Mapea los DTOs de la fuente remota a entidades de dominio y construye el
/// modelo [Paginated]. No contiene estado: la paginación la gestiona el VM.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote);
  final ProductRemoteDataSource _remote;

  @override
  Future<Result<Paginated<Product>>> fetchProducts({
    required int page,
    int pageSize = 20,
  }) async {
    final result = await _remote.fetchProducts(page: page, pageSize: pageSize);

    return result.map(
      (data) => Paginated<Product>(
        items: data.items.map((dto) => dto.toEntity()).toList(),
        page: page,
        hasMore: data.hasMore,
      ),
    );
  }
}
