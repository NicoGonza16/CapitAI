import 'package:capitai/features/products/data/datasource/product_remote_datasource.dart';
import 'package:capitai/features/products/data/repositories/product_repository_impl.dart';
import 'package:capitai/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que expone la implementación de [ProductRepository].
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider)),
);
