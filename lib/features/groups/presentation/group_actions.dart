import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/group_repository_impl.dart';
import '../domain/entities/group_member.dart';
import '../domain/entities/settlement.dart';
import '../domain/entities/shared_expense.dart';
import '../domain/ledger.dart';
import 'group_labels.dart';

Future<void> deleteSharedExpense(WidgetRef ref, SharedExpense expense) async {
  final repository = ref.read(groupRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.deleteExpense(expense.id);
  toast.show(
    'Deleted “${expense.label}”',
    onUndo: () => unawaited(repository.restoreExpense(expense.id)),
  );
}

/// Records one of the suggested transfers as paid, with an undo — "Pay" on
/// the settle-up screen.
Future<void> payTransfer(
  WidgetRef ref,
  String groupId,
  Transfer transfer,
  List<GroupMember> members,
) async {
  final repository = ref.read(groupRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  final settlement = await repository.settle(
    groupId,
    NewSettlement(
      fromMemberId: transfer.fromMemberId,
      toMemberId: transfer.toMemberId,
      amountMinor: transfer.amountMinor,
    ),
  );
  final from = memberNameOrYou(members, transfer.fromMemberId);
  final to = memberNameOrYou(members, transfer.toMemberId);
  toast.show(
    '${Money.inr(transfer.amountMinor)} · $from paid $to',
    onUndo: () => unawaited(repository.deleteSettlement(settlement.id)),
  );
}

/// "Remind" is a push in Phase 5. In v1 it says so rather than pretending —
/// a button that silently did nothing would be the one dead control §12.1.1
/// rules out.
void remindAbout(WidgetRef ref, String name) {
  ref.read(toastControllerProvider.notifier).show(
        'Reminders for $name arrive with shared groups',
      );
}

/// Removes a member, or explains why they cannot go.
///
/// The repository refuses anyone who has touched the group's money, because
/// the ledger would stop balancing. That refusal is a sentence the user can
/// act on, not an error.
Future<void> removeMember(
  BuildContext context,
  WidgetRef ref,
  GroupMember member,
) async {
  final repository = ref.read(groupRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  if (!await repository.canRemoveMember(member.id)) {
    toast.show(
      '${member.displayName} is part of this group’s expenses — delete those '
      'first',
    );
    return;
  }
  if (!context.mounted) return;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Remove ${member.displayName}?'),
      content: const Text('They are not part of anything that was spent.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep them'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: dialogContext.kosha.error,
          ),
          child: const Text('Remove'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  await repository.removeMember(member.id);
  toast.show('Removed ${member.displayName}');
}
