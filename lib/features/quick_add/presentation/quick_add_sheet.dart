import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../calendar/presentation/widgets/new_event_sheet.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import '../../tasks/presentation/widgets/sheet_scaffold.dart';

/// Opens the quick-add grid, reached from every FAB except the Tasks tab's
/// (which already has an obvious job — see `tasks_screen.dart`).
Future<void> showQuickAddSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (_) => const QuickAddSheet(),
  );
}

enum _QuickAddOption {
  task('Task', Symbols.task_alt_rounded),
  reminder('Reminder', Symbols.notifications_rounded),
  note('Note', Symbols.sticky_note_2_rounded),
  expense('Expense', Symbols.account_balance_wallet_rounded),
  shoppingItem('Shopping item', Symbols.shopping_basket_rounded),
  bill('Bill', Symbols.receipt_long_rounded),
  document('Document', Symbols.description_rounded),
  goal('Goal', Symbols.flag_rounded),
  splitWithFriends('Split with friends', Symbols.group_rounded),
  customItem('Custom item', Symbols.add_circle_rounded);

  const _QuickAddOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// 10 options from the prototype. Only Task and Reminder do anything today —
/// everything else needs a feature (Finance, Shopping, Bills…) that Phase 1
/// hasn't built yet, so those tiles toast the same "arriving later" message
/// the rest of the still-missing screens use.
class QuickAddSheet extends ConsumerWidget {
  const QuickAddSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetScaffold(
      title: 'Quick add',
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            for (final option in _QuickAddOption.values)
              _OptionTile(
                option: option,
                onTap: () => unawaited(_choose(context, ref, option)),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    _QuickAddOption option,
  ) async {
    Navigator.of(context).pop();
    switch (option) {
      case _QuickAddOption.task:
        await showNewTaskSheet(context);
      case _QuickAddOption.reminder:
        await showNewEventSheet(context);
      case _QuickAddOption.note:
      case _QuickAddOption.expense:
      case _QuickAddOption.shoppingItem:
      case _QuickAddOption.bill:
      case _QuickAddOption.document:
      case _QuickAddOption.goal:
      case _QuickAddOption.splitWithFriends:
      case _QuickAddOption.customItem:
        ref.read(toastControllerProvider.notifier).show('Arriving in a later phase');
    }
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.option, required this.onTap});

  final _QuickAddOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(option.icon, size: 22, color: c.accent),
              const SizedBox(height: 8),
              Text(
                option.label,
                style: t.labelLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
