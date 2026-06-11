import 'package:equatable/equatable.dart';

/// Página de resultados genérica devuelta por endpoints paginados.
///
/// Modelo reutilizable entre features para no duplicar la lógica de paginación.
class Paginated<T> extends Equatable {
  const Paginated({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  /// Elementos de esta página.
  final List<T> items;

  /// Número de página actual (1-based).
  final int page;

  /// `true` si existen más páginas por cargar.
  final bool hasMore;

  @override
  List<Object?> get props => [items, page, hasMore];
}
