import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../../notifications/data/notification_repository_impl.dart';
import '../data/bill_repository_impl.dart';
import '../domain/entities/bill.dart';
import 'widgets/pay_bill_sheet.dart';

/// Opens the payment sheet and records whatever it collected.
///
/// Returns true when a payment was recorded, so a caller that wants to react
/// (a detail screen scrolling to the new receipt, say) can tell "paid" from
/// "backed out".
Future<bool> payBill(BuildContext context, WidgetRef ref, Bill bill) async {
  final draft = await showPayBillSheet(context, bill: bill);
  if (draft == null) return false;

  final repository = ref.read(billRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);
  final notifications = ref.read(notificationRepositoryProvider);

  final result = await repository.markPaid(
    bill.id,
    amountMinor: draft.amountMinor,
    paidOn: draft.paidOn,
    method: draft.method,
    logExpense: draft.logExpense,
  );

  // Section 6.7: an overdue bill shows up in Needs attention and in the
  // notification inbox, and paying it clears both. Needs attention clears on
  // its own — it reads the bill's own state — while the inbox row is history
  // that stays, so "clearing" it means marking it read.
  await notifications.markReadForOwner(ReminderKind.bill, bill.id);

  final advanced = result.bill.nextDue;
  toast.show(
    advanced == null
        ? 'Paid ${Money.inr(draft.amountMinor)} · ${bill.name}'
        : 'Paid ${Money.inr(draft.amountMinor)} · next on '
            '${Dates.dayMonth(advanced)}',
    // Undo has to put back all three things paying touched: the receipt, the
    // expense it wrote, and the cycle it advanced.
    onUndo: () => unawaited(repository.undoPayment(result)),
  );
  return true;
}

Future<void> deleteBill(WidgetRef ref, Bill bill) async {
  final repository = ref.read(billRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.softDelete(bill.id);
  toast.show(
    'Deleted “${bill.name}”',
    onUndo: () => unawaited(repository.restore(bill.id)),
  );
}

/// Confirms first, then deletes with an undo. Returns true when the bill went.
Future<bool> confirmAndDeleteBill(
  BuildContext context,
  WidgetRef ref,
  Bill bill,
) async {
  final confirmed = await _confirm(context, bill);
  if (!confirmed || !context.mounted) return false;
  await deleteBill(ref, bill);
  return true;
}

Future<bool> _confirm(BuildContext context, Bill bill) async {
  final c = context.kosha;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete this bill?'),
      content: Text(
        bill.repeats
            ? '“${bill.name}” repeats. Deleting it stops the reminders and '
                'removes its payment history. You can undo this straight away.'
            : '“${bill.name}” and its payment history will be removed. You '
                'can undo this straight away.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: c.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
