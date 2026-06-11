import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa un producto del catálogo.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  final String id;
  final String name;
  final double price;
  final String? description;

  @override
  List<Object?> get props => [id, name, price, description];
}
