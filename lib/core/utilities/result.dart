import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';

/// Patrón Result (sealed) que modela de forma explícita éxito o fallo.
///
/// Evita propagar excepciones por toda la app y obliga al consumidor a tratar
/// ambos casos mediante exhaustividad del `switch`. Las capas de datos
/// devuelven `Result<T>` en lugar de lanzar, y los ViewModels lo consumen sin
/// `try/catch` repetidos.
sealed class Result<T> {
  const Result();

  /// Crea un resultado exitoso.
  const factory Result.success(T value) = Success<T>;

  /// Crea un resultado fallido.
  const factory Result.failure(AppException error) = Failure<T>;

  /// `true` si la operación fue exitosa.
  bool get isSuccess => this is Success<T>;

  /// Ejecuta el callback correspondiente al estado actual.
  R when<R>({
    required R Function(T value) success,
    required R Function(AppException error) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => success(self.value),
      Failure<T>() => failure(self.error),
    };
  }

  /// Transforma el valor de un [Success] manteniendo el [Failure] intacto.
  Result<R> map<R>(R Function(T value) transform) => when(
        success: (value) => Result.success(transform(value)),
        failure: Result.failure,
      );

  /// Devuelve el valor o `null` si fue un fallo.
  T? get valueOrNull => this is Success<T> ? (this as Success<T>).value : null;
}

/// Variante exitosa de [Result].
final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

/// Variante fallida de [Result].
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;
}
