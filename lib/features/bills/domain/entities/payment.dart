import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../finance/domain/entities/transaction.dart';

part 'payment.freezed.dart';

/// One settled cycle of a bill — the receipt history on Bill detail.
///
/// [transactionId] links the expense that was written to Finance at the same
/// moment, when the user asked for one. Deleting the transaction later does
/// not delete the payment: the bill *was* paid either way, and the link is
/// only used to open the transaction from the payment row.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String billId,

    /// Local midnight of the day the payment was made.
    required DateTime paidOn,
    required int amountMinor,
    required DateTime createdAt,
    TransactionMethod? method,
    String? transactionId,

    /// The due date this payment settled, kept so the history still reads
    /// correctly after `nextDue` has moved on.
    DateTime? forDueDate,
  }) = _Payment;
}
