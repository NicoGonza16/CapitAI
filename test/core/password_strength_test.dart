import 'package:capitai/core/utilities/password_strength.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordStrength', () {
    test('detecta cada requisito por separado', () {
      final s = PasswordStrength.of('abcdefgh');
      expect(s.hasMinLength, isTrue);
      expect(s.hasUppercase, isFalse);
      expect(s.hasNumber, isFalse);
      expect(s.hasSpecial, isFalse);
      expect(s.isValid, isFalse);
    });

    test('isValid solo cuando cumple todos', () {
      expect(PasswordStrength.of('Abcdef1!').isValid, isTrue);
      expect(PasswordStrength.of('Abc1!').isValid, isFalse); // corta
      expect(PasswordStrength.of('abcdef1!').isValid, isFalse); // sin mayúscula
      expect(PasswordStrength.of('Abcdefg!').isValid, isFalse); // sin número
      expect(PasswordStrength.of('Abcdefg1').isValid, isFalse); // sin especial
    });
  });
}
