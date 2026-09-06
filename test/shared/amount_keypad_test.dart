import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/shared/widgets/amount_keypad.dart';

void main() {
  group('AmountKeypad.pressKey', () {
    test('appends digits', () {
      expect(AmountKeypad.pressKey('12', '3'), '123');
    });

    test('starts a decimal with "0." when empty', () {
      expect(AmountKeypad.pressKey('', '.'), '0.');
    });

    test('appends "." once', () {
      expect(AmountKeypad.pressKey('150', '.'), '150.');
      expect(AmountKeypad.pressKey('150.5', '.'), '150.5');
    });

    test('caps decimals at 2 digits', () {
      expect(AmountKeypad.pressKey('150.5', '5'), '150.55');
      expect(AmountKeypad.pressKey('150.55', '5'), '150.55');
    });

    test('caps the whole value at 9 characters', () {
      expect(AmountKeypad.pressKey('12345678', '9'), '123456789');
      expect(AmountKeypad.pressKey('123456789', '0'), '123456789');
    });

    test('backspace removes the last character', () {
      expect(AmountKeypad.pressKey('150.5', 'backspace'), '150.');
    });

    test('backspace on empty stays empty', () {
      expect(AmountKeypad.pressKey('', 'backspace'), '');
    });
  });
}
