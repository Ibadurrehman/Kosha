import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/amount_keypad.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';

/// Opens the New expense sheet — the custom keypad from section 6.6.
Future<void> showNewExpenseSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewExpenseSheet(),
  );
}

String _methodLabel(TransactionMethod method) => switch (method) {
      TransactionMethod.upi => 'UPI',
      TransactionMethod.card => 'Card',
      TransactionMethod.cash => 'Cash',
      TransactionMethod.autopay => 'Autopay',
    };

/// Amount, type, category, method and an optional note. Transaction
/// detail/edit and pre-linking from Vehicle/a space arrive in a later Phase 2
/// slice (section 6.6's "Added" screens) — this is the flow the prototype's
/// `pressKey` proves out.
class NewExpenseSheet extends ConsumerStatefulWidget {
  const NewExpenseSheet({super.key});

  @override
  ConsumerState<NewExpenseSheet> createState() => _NewExpenseSheetState();
}

class _NewExpenseSheetState extends ConsumerState<NewExpenseSheet> {
  String _amount = '';
  TransactionType _type = TransactionType.expense;
  String? _category;
  TransactionMethod? _method;
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(_loadLastMethod());
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadLastMethod() async {
    final last = await ref.read(transactionRepositoryProvider).lastMethod();
    if (mounted && last != null) setState(() => _method = last);
  }

  int get _amountMinor {
    if (_amount.isEmpty || _amount == '.') return 0;
    final value = double.tryParse(_amount) ?? 0;
    return (value * 100).round();
  }

  bool get _canSave => _amountMinor > 0;

  Future<void> _save() async {
    if (!_canSave) return;

    final repository = ref.read(transactionRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final today = ref.read(clockProvider).today();
    final amountMinor = _amountMinor;
    final type = _type;

    final draft = NewTransaction(
      amountMinor: amountMinor,
      type: type,
      date: today,
      category: type == TransactionType.expense ? _category : null,
      method: _method,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );

    Navigator.of(context).pop();
    final transaction = await repository.create(draft);
    toast.show(
      '${type == TransactionType.expense ? 'Expense' : 'Income'} of '
      '${Money.inr(amountMinor)} added',
      onUndo: () => unawaited(repository.purge(transaction.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return SheetScaffold(
      title: 'New expense',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KoshaChip(
              label: 'Expense',
              selected: _type == TransactionType.expense,
              onTap: () => setState(() => _type = TransactionType.expense),
            ),
            const SizedBox(width: 8),
            KoshaChip(
              label: 'Income',
              selected: _type == TransactionType.income,
              onTap: () => setState(() => _type = TransactionType.income),
            ),
          ],
        ),
        const SizedBox(height: 18),
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
        if (_type == TransactionType.expense) ...[
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Category', style: t.labelMedium?.copyWith(color: c.text2)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in expenseCategories)
                KoshaChip(
                  label: category,
                  selected: _category == category,
                  onTap: () => setState(
                    () => _category = _category == category ? null : category,
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Method', style: t.labelMedium?.copyWith(color: c.text2)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final method in TransactionMethod.values)
              KoshaChip(
                label: _methodLabel(method),
                selected: _method == method,
                onTap: () => setState(
                  () => _method = _method == method ? null : method,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _note,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Note (optional)'),
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
                onPressed: _canSave ? () => unawaited(_save()) : null,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
