import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/products/domain/entities/product.dart';
import 'package:enterprise_flutter_template/shared/models/paginated.dart';

/// Contrato del repositorio de productos (capa de dominio).
abstract interface class ProductRepository {
  /// Obtiene una página del catálogo de productos.
  Future<Result<Paginated<Product>>> fetchProducts({
    required int page,
    int pageSize,
  });
}
