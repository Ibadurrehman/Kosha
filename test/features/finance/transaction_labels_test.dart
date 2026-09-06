import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/transaction_labels.dart';
import 'package:kosha/shared/widgets/amount_keypad.dart';

void main() {
  Transaction transaction({
    String? label,
    String? category,
    TransactionType type = TransactionType.expense,
  }) =>
      Transaction(
        id: 't1',
        amountMinor: 45000,
        type: type,
        date: DateTime(2026, 9, 4),
        label: label,
        category: category,
        createdAt: DateTime(2026, 9, 4),
        updatedAt: DateTime(2026, 9, 4),
      );

  group('amountFieldText', () {
    test('whole rupees carry no decimal point', () {
      expect(amountFieldText(185000), '1850');
      expect(amountFieldText(0), '0');
    });

    test('a trailing zero in the paise is dropped', () {
      expect(amountFieldText(185050), '1850.5');
    });

    test('both paise digits are kept, zero-padded', () {
      expect(amountFieldText(185005), '1850.05');
      expect(amountFieldText(185099), '1850.99');
    });
  });

  group('parseAmountMinor', () {
    test('reads what the keypad produces', () {
      expect(parseAmountMinor('1850'), 185000);
      expect(parseAmountMinor('1850.5'), 185050);
      expect(parseAmountMinor('1850.05'), 185005);
    });

    test('an empty or half-typed amount is zero, which is what gates Save', () {
      expect(parseAmountMinor(''), 0);
      expect(parseAmountMinor('.'), 0);
    });

    test('round-trips every amount the keypad can produce', () {
      for (final minor in [0, 1, 50, 99, 100, 45000, 185005, 185050, 999999999]) {
        expect(
          parseAmountMinor(amountFieldText(minor)),
          minor,
          reason: '$minor did not survive the round trip',
        );
      }
    });

    test('what amountFieldText produces is a valid keypad state', () {
      // Re-opening an amount in the editor must leave the keypad's own caps
      // (9 characters, 2 decimals) applying to whatever is typed next.
      const text = '1850.5';
      expect(AmountKeypad.pressKey(text, '5'), '1850.55');
      expect(AmountKeypad.pressKey('1850.55', '5'), '1850.55');
    });
  });

  group('transactionTitle', () {
    test('prefers the label', () {
      expect(
        transactionTitle(transaction(label: 'Big Bazaar', category: 'Groceries')),
        'Big Bazaar',
      );
    });

    test('falls back to the category, then to the kind', () {
      expect(transactionTitle(transaction(category: 'Groceries')), 'Groceries');
      expect(transactionTitle(transaction()), 'Expense');
      expect(
        transactionTitle(transaction(type: TransactionType.income)),
        'Income',
      );
    });
  });

  group('methodLabel', () {
    test('UPI keeps its capitals', () {
      expect(methodLabel(TransactionMethod.upi), 'UPI');
      expect(methodLabel(TransactionMethod.autopay), 'Autopay');
    });
  });
}
