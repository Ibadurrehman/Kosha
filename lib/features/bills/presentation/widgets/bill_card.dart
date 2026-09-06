import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/bill.dart';
import '../bill_labels.dart';

/// One bill on the Bills screen: name, amount, status pill and the two
/// actions that make sense for where it stands (section 6.7).
class BillCard extends StatelessWidget {
  const BillCard({
    super.key,
    required this.bill,
    required this.today,
    required this.onOpen,
    required this.onPay,
  });

  final Bill bill;
  final DateTime today;
  final VoidCallback onOpen;

  /// Null when there is nothing to pay — a settled one-off.
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final status = billStatus(bill, today);
    // Section 6.7: the second action follows the status. A bill that is
    // settled for this cycle offers its receipt rather than "Pay now", which
    // would otherwise invite paying the next cycle by accident.
    final settled = status == BillStatus.paid;
    final canPay = onPay != null && bill.nextDue != null && !settled;

    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        side: BorderSide(
          color: status == BillStatus.overdue ? c.error : c.border,
        ),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconTile(
                    bill.kind == BillKind.subscription
                        ? Symbols.autorenew_rounded
                        : Symbols.receipt_long_rounded,
                    color: status == BillStatus.overdue ? c.error : c.text2,
                    background:
                        status == BillStatus.overdue ? c.errorSoft : c.sunk,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.name,
                          style: t.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          [
                            billFrequencyLabel(bill),
                            if (bill.autopay) 'Autopay',
                            if (bill.provider != null) bill.provider!,
                          ].join(' · '),
                          style: t.bodySmall?.copyWith(color: c.text3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Money.inr(bill.amountMinor),
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatusPill(
                    billPillStatus(status),
                    label: billBadgeLabel(bill, today),
                    icon: Symbols.schedule_rounded,
                  ),
                  const Spacer(),
                  TextButton(onPressed: onOpen, child: const Text('Manage')),
                  if (canPay)
                    TextButton(
                      onPressed: onPay,
                      child: Text(bill.autopay ? 'Mark as paid' : 'Pay now'),
                    )
                  else if (settled && bill.lastPaidOn != null)
                    // The receipt history lives on the detail screen, which is
                    // where "Manage" goes too — the wording is what differs,
                    // because what the user wants there is different.
                    TextButton(
                      onPressed: onOpen,
                      child: const Text('View receipt'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
