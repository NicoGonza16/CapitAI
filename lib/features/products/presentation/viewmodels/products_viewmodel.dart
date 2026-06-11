import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:enterprise_flutter_template/features/products/domain/entities/product.dart';
import 'package:enterprise_flutter_template/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel del catálogo paginado (patrón MVVM).
///
/// Ejemplo de [AsyncNotifier] con **paginación incremental**: `build` carga la
/// primera página; `loadMore` anexa la siguiente conservando la lista actual.
/// El estado expuesto a la View es `AsyncValue<List<Product>>`, por lo que la
/// UI obtiene loading/error/data de forma declarativa.
class ProductsViewModel extends AsyncNotifier<List<Product>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  /// `true` mientras existan más páginas por cargar.
  bool get hasMore => _hasMore;

  @override
  Future<List<Product>> build() async {
    _page = 1;
    return _fetchPage(1);
  }

  /// Carga la siguiente página y la anexa al estado actual.
  ///
  /// Es idempotente ante llamadas concurrentes y respeta [hasMore], evitando
  /// peticiones innecesarias al llegar al final de la lista.
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final current = state.valueOrNull ?? const [];
    try {
      final next = await _fetchPage(_page + 1);
      _page += 1;
      state = AsyncData([...current, ...next]);
    } catch (error, stackTrace) {
      // Conserva los datos ya cargados y adjunta el error para mostrar feedback.
      state = AsyncError<List<Product>>(error, stackTrace)
          .copyWithPrevious(state);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Reinicia la paginación desde la primera página (pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    _hasMore = true;
    state = await AsyncValue.guard(() => _fetchPage(1).then((items) {
          _page = 1;
          return items;
        }));
  }

  /// Pide una página al caso de uso y traduce el [Result] a datos o excepción.
  Future<List<Product>> _fetchPage(int page) async {
    final result = await ref.read(getProductsUseCaseProvider)(page: page);
    switch (result) {
      case Success(:final value):
        _hasMore = value.hasMore;
        return value.items;
      case Failure(:final error):
        throw error;
    }
  }
}

/// Provider del ViewModel del catálogo.
final productsViewModelProvider =
    AsyncNotifierProvider<ProductsViewModel, List<Product>>(
  ProductsViewModel.new,
);
