import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/settings/settings_store.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/amount_keypad.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/finance_settings.dart';
import '../controllers/finance_providers.dart';
import '../transaction_labels.dart';

/// Sets the monthly-budget fallback from ADR 0006 (D4) — the figure Finance
/// shows as "Budgeted" while a month has no income transaction of its own.
Future<void> showMonthlyBudgetSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const MonthlyBudgetSheet(),
  );
}

class MonthlyBudgetSheet extends ConsumerStatefulWidget {
  const MonthlyBudgetSheet({super.key});

  @override
  ConsumerState<MonthlyBudgetSheet> createState() => _MonthlyBudgetSheetState();
}

class _MonthlyBudgetSheetState extends ConsumerState<MonthlyBudgetSheet> {
  String _amount = '';
  bool _seeded = false;

  Future<void> _save() async {
    final store = ref.read(settingsStoreProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final amountMinor = parseAmountMinor(_amount);

    Navigator.of(context).pop();
    await writeMonthlyBudgetMinor(store, amountMinor);
    ref.invalidate(monthlyBudgetMinorProvider);
    toast.show('Monthly budget set to ${Money.inr(amountMinor)}');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    // Pre-fills once with whatever is already stored, then leaves the field
    // alone — a later emission must not overwrite what the user is typing.
    final stored = ref.watch(monthlyBudgetMinorProvider);
    if (!_seeded) {
      stored.whenData((minor) {
        _seeded = true;
        if (minor != null && minor > 0) _amount = amountFieldText(minor);
      });
    }

    return SheetScaffold(
      title: 'Monthly budget',
      subtitle: 'Shown as "Budgeted" until the month has income of its own.',
      children: [
        const SizedBox(height: 8),
        Center(
          child: Text(
            _amount.isEmpty ? '₹0' : '₹$_amount',
            style: t.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 18),
        AmountKeypad(
          value: _amount,
          onChanged: (v) => setState(() => _amount = v),
        ),
        const SizedBox(height: 18),
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
                onPressed: () => unawaited(_save()),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Setting this to ₹0 hides the fallback entirely.',
          style: t.bodySmall?.copyWith(color: c.text3),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
