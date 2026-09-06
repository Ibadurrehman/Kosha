import '../domain/entities/transaction.dart';

/// "UPI" / "Card" — how a payment method reads in the UI.
String methodLabel(TransactionMethod method) => switch (method) {
      TransactionMethod.upi => 'UPI',
      TransactionMethod.card => 'Card',
      TransactionMethod.cash => 'Cash',
      TransactionMethod.autopay => 'Autopay',
    };

/// What a transaction row calls itself when it has no label of its own.
String transactionTitle(Transaction transaction) {
  final label = transaction.label;
  if (label != null && label.isNotEmpty) return label;
  final category = transaction.category;
  if (category != null && category.isNotEmpty) return category;
  return transaction.type == TransactionType.income ? 'Income' : 'Expense';
}

/// Minor units as the keypad would have them: `185000` → `"1850"`,
/// `185050` → `"1850.5"`.
///
/// Trailing zeros are dropped so re-opening an amount in the editor gives the
/// same string the user would have typed, and the keypad's own two-decimal
/// cap keeps applying to whatever they type next.
String amountFieldText(int amountMinor) {
  final rupees = amountMinor ~/ 100;
  final paise = amountMinor % 100;
  if (paise == 0) return '$rupees';
  if (paise % 10 == 0) return '$rupees.${paise ~/ 10}';
  return '$rupees.${paise.toString().padLeft(2, '0')}';
}

/// The keypad's string back to minor units. Anything that is not a number —
/// an empty field, a lone "." — is zero, which is what gates Save.
int parseAmountMinor(String text) {
  if (text.isEmpty || text == '.') return 0;
  final value = double.tryParse(text);
  if (value == null) return 0;
  return (value * 100).round();
}
