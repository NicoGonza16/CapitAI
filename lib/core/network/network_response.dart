/// Envoltura ligera y tipada de una respuesta HTTP exitosa.
///
/// Desacopla la app del objeto `Response` de Dio, exponiendo solo lo necesario.
class NetworkResponse<T> {
  const NetworkResponse({
    required this.data,
    required this.statusCode,
  });

  /// Cuerpo deserializado de la respuesta.
  final T data;

  /// Código HTTP devuelto por el servidor.
  final int statusCode;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
