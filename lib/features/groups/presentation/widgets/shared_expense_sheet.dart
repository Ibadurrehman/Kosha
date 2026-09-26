import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/group_repository_impl.dart';
import '../../domain/entities/group_member.dart';
import '../../domain/entities/shared_expense.dart';
import '../group_labels.dart';
import 'member_avatar.dart';

/// Add a shared expense (§6.14): amount keypad, label, who paid, who it is
/// split between, and what that comes to each.
Future<void> showSharedExpenseSheet(
  BuildContext context, {
  required String groupId,
  required List<GroupMember> members,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => SharedExpenseSheet(groupId: groupId, members: members),
  );
}

class SharedExpenseSheet extends ConsumerStatefulWidget {
  const SharedExpenseSheet({
    super.key,
    required this.groupId,
    required this.members,
  });

  final String groupId;
  final List<GroupMember> members;

  @override
  ConsumerState<SharedExpenseSheet> createState() => _SharedExpenseSheetState();
}

class _SharedExpenseSheetState extends ConsumerState<SharedExpenseSheet> {
  late final TextEditingController _label = TextEditingController();
  String _amount = '';
  late String _paidById =
      (selfMember(widget.members) ?? widget.members.first).id;
  late Set<String> _splitWith = {for (final m in widget.members) m.id};
  SplitMode _mode = SplitMode.equally;
  String _iconKey = sharedExpenseIconPicks.first;

  @override
  void initState() {
    super.initState();
    _label.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  int get _amountMinor => parseAmountMinor(_amount);

  bool get _canSave => _amountMinor > 0 && _splitWith.isNotEmpty;

  /// The split, in the group's own member order — the order the ledger walks,
  /// and therefore the order a remainder paisa is handed out in.
  List<String> get _splitIds => [
        for (final member in widget.members)
          if (_splitWith.contains(member.id)) member.id,
      ];

  void _pickMode(SplitMode mode) {
    setState(() {
      _mode = mode;
      switch (mode) {
        case SplitMode.equally:
          _splitWith = {for (final m in widget.members) m.id};
        case SplitMode.onlyMe:
          final self = selfMember(widget.members);
          _splitWith = {if (self != null) self.id};
        case SplitMode.custom:
          // Keeps whoever is already ticked; Custom is a starting point, not
          // a reset.
          break;
      }
    });
  }

  /// Ticking or unticking anybody makes the split Custom — §6.14's rule, and
  /// the only honest reading: the chips would otherwise say "Equally" about a
  /// split that is not equal across the group.
  void _toggleMember(String memberId) {
    setState(() {
      if (_splitWith.contains(memberId)) {
        _splitWith.remove(memberId);
      } else {
        _splitWith.add(memberId);
      }
      _mode = SplitMode.custom;
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(groupRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final label = _label.text.trim();
    final amountMinor = _amountMinor;
    final splitIds = _splitIds;

    Navigator.of(context).pop();

    final expense = await repository.addExpense(
      widget.groupId,
      NewSharedExpense(
        label: label.isEmpty ? 'Shared expense' : label,
        amountMinor: amountMinor,
        paidByMemberId: _paidById,
        memberIds: splitIds,
        splitMode: _mode,
        iconKey: _iconKey,
      ),
    );

    toast.show(
      splitSummary(amountMinor, splitIds.length),
      onUndo: () => unawaited(repository.deleteExpense(expense.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return SheetScaffold(
      title: 'Add a shared expense',
      children: [
        Text(
          _amountMinor == 0 ? '₹0' : Money.inrExact(_amountMinor),
          style: t.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: KoshaSpace.md),
        AmountKeypad(
          value: _amount,
          onChanged: (value) => setState(() => _amount = value),
        ),
        const SizedBox(height: KoshaSpace.lg),
        TextField(
          controller: _label,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'What for',
            hintText: 'Dinner at Gunpowder',
          ),
        ),
        const SizedBox(height: KoshaSpace.lg),
        Text('Paid by', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.sm),
        Wrap(
          spacing: KoshaSpace.sm,
          runSpacing: KoshaSpace.sm,
          children: [
            for (final member in widget.members)
              KoshaChip(
                label: member.isSelf ? 'You' : member.displayName,
                selected: member.id == _paidById,
                onTap: () => setState(() => _paidById = member.id),
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.lg),
        Text('Split', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.sm),
        Wrap(
          spacing: KoshaSpace.sm,
          runSpacing: KoshaSpace.sm,
          children: [
            for (final mode in SplitMode.values)
              KoshaChip(
                label: mode.label,
                selected: mode == _mode,
                onTap: () => _pickMode(mode),
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.md),
        for (final member in widget.members)
          _SplitRow(
            member: member,
            selected: _splitWith.contains(member.id),
            // Each head's own share, so an uneven split shows the paisa where
            // it actually lands rather than one rounded figure for everybody.
            shareMinor: _splitWith.contains(member.id)
                ? splitEqually(_amountMinor, _splitIds)[member.id]
                : null,
            onTap: () => _toggleMember(member.id),
          ),
        const SizedBox(height: KoshaSpace.md),
        Text('Icon', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.sm),
        Wrap(
          spacing: KoshaSpace.sm,
          runSpacing: KoshaSpace.sm,
          children: [
            for (final key in sharedExpenseIconPicks)
              KoshaChip(
                label: '',
                icon: sharedExpenseIcon(key),
                selected: key == _iconKey,
                onTap: () => setState(() => _iconKey = key),
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.lg),
        Text(
          _splitWith.isEmpty
              ? 'Pick at least one person to split with'
              : splitSummary(_amountMinor, _splitWith.length),
          style: t.bodyMedium?.copyWith(
            color: _splitWith.isEmpty ? c.warning : c.text2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: KoshaSpace.md),
        FilledButton(
          onPressed: _canSave ? () => unawaited(_save()) : null,
          child: const Text('Add expense'),
        ),
      ],
    );
  }
}

class _SplitRow extends StatelessWidget {
  const _SplitRow({
    required this.member,
    required this.selected,
    required this.shareMinor,
    required this.onTap,
  });

  final GroupMember member;
  final bool selected;
  final int? shareMinor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KoshaRadius.row),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            MemberAvatar(member: member, size: 30),
            const SizedBox(width: KoshaSpace.md),
            Expanded(
              child: Text(
                member.isSelf ? 'You' : member.displayName,
                style: t.bodyMedium,
              ),
            ),
            if (shareMinor != null)
              Text(
                Money.inrExact(shareMinor!),
                style: t.bodySmall?.copyWith(color: c.text2),
              ),
            const SizedBox(width: KoshaSpace.sm),
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              semanticLabel: 'Split with ${member.displayName}',
            ),
          ],
        ),
      ),
    );
  }
}
