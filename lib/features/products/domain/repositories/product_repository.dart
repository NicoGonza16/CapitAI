import 'package:capitai/core/utilities/result.dart';
import 'package:capitai/features/products/domain/entities/product.dart';
import 'package:capitai/shared/models/paginated.dart';

/// Contrato del repositorio de productos (capa de dominio).
abstract interface class ProductRepository {
  /// Obtiene una página del catálogo de productos.
  Future<Result<Paginated<Product>>> fetchProducts({
    required int page,
    int pageSize,
  });
}
