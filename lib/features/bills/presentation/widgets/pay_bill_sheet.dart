import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/recurrence/recurrence.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/amount_keypad.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../../shared/widgets/kosha_toggle.dart';
import '../../../finance/domain/entities/transaction.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/bill.dart';

/// What the payment sheet collected. Null from [showPayBillSheet] means the
/// user backed out.
class PaymentDraft {
  const PaymentDraft({
    required this.amountMinor,
    required this.paidOn,
    required this.logExpense,
    this.method,
  });

  final int amountMinor;
  final DateTime paidOn;
  final TransactionMethod? method;

  /// Whether to write a matching Finance expense alongside the receipt.
  final bool logExpense;
}

/// Amount, date, method, and whether the payment should also show up in
/// Finance (section 6.7's Payment sheet).
Future<PaymentDraft?> showPayBillSheet(BuildContext context, {required Bill bill}) {
  return showModalBottomSheet<PaymentDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _PayBillSheet(bill: bill),
  );
}

class _PayBillSheet extends ConsumerStatefulWidget {
  const _PayBillSheet({required this.bill});

  final Bill bill;

  @override
  ConsumerState<_PayBillSheet> createState() => _PayBillSheetState();
}

class _PayBillSheetState extends ConsumerState<_PayBillSheet> {
  late String _amount = amountFieldText(widget.bill.amountMinor);
  late TransactionMethod? _method =
      widget.bill.autopay ? TransactionMethod.autopay : null;
  DateTime? _paidOn;
  bool _logExpense = true;

  DateTime get _effectiveDate => _paidOn ?? ref.read(clockProvider).today();

  bool get _canSave => parseAmountMinor(_amount) > 0;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime(today.year - 5),
      lastDate: today,
    );
    if (picked != null && mounted) {
      setState(() => _paidOn = DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final bill = widget.bill;
    final due = bill.nextDue;
    final advanced = due == null || !bill.repeats
        ? null
        : Recurrence.nextAfter(bill.frequencyRule, due);

    return SheetScaffold(
      title: 'Pay ${bill.name}',
      subtitle: due == null ? null : 'Due ${Dates.dayMonthYear(due)}',
      children: [
        const SizedBox(height: 6),
        Center(
          child: Text(
            _amount.isEmpty ? '₹0' : '₹$_amount',
            style: t.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 16),
        AmountKeypad(
          value: _amount,
          onChanged: (v) => setState(() => _amount = v),
        ),
        const SizedBox(height: 14),
        const _Label('Paid on'),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: KoshaChip(
            label: Dates.dayMonthYear(_effectiveDate),
            icon: Symbols.event_rounded,
            selected: false,
            onTap: () => unawaited(_pickDate()),
          ),
        ),
        const SizedBox(height: 14),
        const _Label('Method'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final method in TransactionMethod.values)
              KoshaChip(
                label: methodLabel(method),
                selected: _method == method,
                onTap: () => setState(
                  () => _method = _method == method ? null : method,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Also log it as an expense'),
          subtitle: const Text('Counts towards this month on Finance'),
          trailing: KoshaToggle(
            value: _logExpense,
            semanticLabel: 'Also log it as an expense',
            onChanged: (value) => setState(() => _logExpense = value),
          ),
        ),
        if (advanced != null) ...[
          const SizedBox(height: 4),
          Text(
            'Next ${bill.kind == BillKind.subscription ? 'renewal' : 'due date'} '
            'moves to ${Dates.dayMonthYear(advanced)}.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
        ] else if (due != null) ...[
          const SizedBox(height: 4),
          Text(
            'This is a one-off, so paying it clears the due date.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              tooltip: 'Cancel',
              icon: const Icon(Symbols.close_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: _canSave
                    ? () => Navigator.of(context).pop(
                          PaymentDraft(
                            amountMinor: parseAmountMinor(_amount),
                            paidOn: _effectiveDate,
                            method: _method,
                            logExpense: _logExpense,
                          ),
                        )
                    : null,
                child: const Text('Mark as paid'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: context.kosha.text2),
        ),
      );
}
