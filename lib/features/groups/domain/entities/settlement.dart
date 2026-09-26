import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';

/// How a settlement was paid. Persisted by index — append only.
enum SettlementMethod {
  cash('Cash'),
  upi('UPI'),
  bankTransfer('Bank transfer'),
  other('Other');

  const SettlementMethod(this.label);

  final String label;
}

/// One member paying another back — what "Pay" on the settle-up screen
/// records.
///
/// Append-only, the shape `Payments` and `FuelLogs` already use: a settlement
/// is a fact about a moment. Getting one wrong is undone by deleting it, not
/// by editing the amount, so the ledger always adds up to what actually
/// happened.
@freezed
abstract class Settlement with _$Settlement {
  const factory Settlement({
    required String id,
    required String groupId,
    required String fromMemberId,
    required String toMemberId,
    required int amountMinor,
    required DateTime recordedAt,
    required DateTime createdAt,
    @Default(SettlementMethod.cash) SettlementMethod method,
    String? note,
    DateTime? deletedAt,
  }) = _Settlement;

  const Settlement._();

  bool get isDeleted => deletedAt != null;
}

/// Fields a caller supplies to record a settlement.
class NewSettlement {
  const NewSettlement({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountMinor,
    this.method = SettlementMethod.cash,
    this.note,
    this.recordedAt,
  });

  final String fromMemberId;
  final String toMemberId;
  final int amountMinor;
  final SettlementMethod method;
  final String? note;
  final DateTime? recordedAt;
}
