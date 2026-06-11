import 'package:enterprise_flutter_template/core/utilities/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('acepta correos bien formados', () {
      expect(Validators.isValidEmail('ada@example.com'), isTrue);
      expect(Validators.isValidEmail('a.b-c@sub.domain.io'), isTrue);
    });

    test('rechaza correos inválidos', () {
      expect(Validators.isValidEmail('no-email'), isFalse);
      expect(Validators.isValidEmail('a@b'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.isValidPassword', () {
    test('exige longitud mínima', () {
      expect(Validators.isValidPassword('12345'), isFalse);
      expect(Validators.isValidPassword('123456'), isTrue);
    });
  });
}
