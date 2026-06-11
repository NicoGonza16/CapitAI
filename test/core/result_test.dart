import 'package:enterprise_flutter_template/core/exceptions/app_exception.dart';
import 'package:enterprise_flutter_template/core/utilities/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success expone valor y when ejecuta la rama de éxito', () {
      const result = Result.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
      expect(
        result.when(success: (v) => 'ok:$v', failure: (_) => 'err'),
        'ok:42',
      );
    });

    test('Failure expone error y when ejecuta la rama de fallo', () {
      const error = ValidationException('bad');
      const result = Result<int>.failure(error);

      expect(result.isSuccess, isFalse);
      expect(result.valueOrNull, isNull);
      expect(
        result.when(success: (_) => 'ok', failure: (e) => e.message),
        'bad',
      );
    });

    test('map transforma Success y conserva Failure', () {
      const success = Result.success(2);
      expect(success.map((v) => v * 10).valueOrNull, 20);

      const failure = Result<int>.failure(CacheException('x'));
      expect(failure.map((v) => v * 10).isSuccess, isFalse);
    });
  });
}
