import 'package:capitai/features/products/domain/entities/product.dart';
import 'package:capitai/features/products/presentation/viewmodels/products_viewmodel.dart';
import 'package:capitai/features/products/presentation/widgets/product_tile.dart';
import 'package:capitai/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla del catálogo paginado.
///
/// View "delgada": observa `AsyncValue<List<Product>>` y dispara `loadMore` al
/// acercarse al final del scroll. Toda la lógica de paginación vive en el VM.
class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(productsViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsViewModelProvider);
    final viewModel = ref.read(productsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: switch (state) {
        AsyncLoading(:final value) when value == null =>
          const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final value) when value == null =>
          ErrorView(message: '$error', onRetry: viewModel.refresh),
        _ => RefreshIndicator(
            onRefresh: viewModel.refresh,
            child: _ProductList(
              products: state.requireValue,
              hasMore: viewModel.hasMore,
              controller: _scrollController,
            ),
          ),
      },
    );
  }
}

/// Lista de productos con indicador de carga al final.
class _ProductList extends StatelessWidget {
  const _ProductList({
    required this.products,
    required this.hasMore,
    required this.controller,
  });

  final List<Product> products;
  final bool hasMore;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: products.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ProductTile(product: products[index]);
      },
    );
  }
}
