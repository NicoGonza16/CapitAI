import 'package:enterprise_flutter_template/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Elemento de lista que representa un [Product].
class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.shopping_bag_outlined)),
      title: Text(product.name),
      subtitle: product.description != null ? Text(product.description!) : null,
      trailing: Text(
        currency.format(product.price),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
