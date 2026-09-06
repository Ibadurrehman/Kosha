import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/transaction_repository_impl.dart';
import '../domain/entities/transaction.dart';
import 'transaction_labels.dart';

/// Deletes a transaction with an undo, the way every other delete in the app
/// works.
Future<void> deleteTransaction(WidgetRef ref, Transaction transaction) async {
  final repository = ref.read(transactionRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.softDelete(transaction.id);
  toast.show(
    'Deleted ${Money.inr(transaction.amountMinor)} · '
    '${transactionTitle(transaction)}',
    onUndo: () => unawaited(repository.restore(transaction.id)),
  );
}

/// Confirms first, then deletes. Returns true when the transaction went, so a
/// detail screen knows to leave.
Future<bool> confirmAndDeleteTransaction(
  BuildContext context,
  WidgetRef ref,
  Transaction transaction,
) async {
  final confirmed = await _confirm(context, transaction);
  if (!confirmed || !context.mounted) return false;
  await deleteTransaction(ref, transaction);
  return true;
}

Future<bool> _confirm(BuildContext context, Transaction transaction) async {
  final c = context.kosha;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete this transaction?'),
      content: Text(
        '${Money.inr(transaction.amountMinor)} · '
        '${transactionTitle(transaction)} will stop counting towards this '
        "month's totals. You can undo this straight away.",
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
