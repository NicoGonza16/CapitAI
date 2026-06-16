import 'package:capitai/features/products/domain/entities/product.dart';

/// DTO del producto tal como lo devuelve la API.
class ProductDto {
  const ProductDto({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  final String id;
  final String name;
  final double price;
  final String? description;

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
        id: json['id'].toString(),
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String?,
      );

  /// Convierte el DTO en entidad de dominio.
  Product toEntity() => Product(
        id: id,
        name: name,
        price: price,
        description: description,
      );
}
