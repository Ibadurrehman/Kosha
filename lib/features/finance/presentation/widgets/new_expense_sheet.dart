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
import '../category_icons.dart';
import '../controllers/finance_providers.dart';
import '../transaction_labels.dart';

/// Opens the New expense sheet — the custom keypad from section 6.6.
///
/// [billId], [spaceId] and [vehicleId] pre-link the transaction to whatever
/// the user came from, which is how "Add expense" on a bill or a space files
/// straight into that record.
Future<void> showNewExpenseSheet(
  BuildContext context, {
  String? billId,
  String? spaceId,
  String? vehicleId,
  String? label,
  int? amountMinor,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => NewExpenseSheet(
      billId: billId,
      spaceId: spaceId,
      vehicleId: vehicleId,
      initialLabel: label,
      initialAmountMinor: amountMinor,
    ),
  );
}

/// Amount, type, date, category, method, label and an optional note.
class NewExpenseSheet extends ConsumerStatefulWidget {
  const NewExpenseSheet({
    super.key,
    this.billId,
    this.spaceId,
    this.vehicleId,
    this.initialLabel,
    this.initialAmountMinor,
  });

  final String? billId;
  final String? spaceId;
  final String? vehicleId;
  final String? initialLabel;
  final int? initialAmountMinor;

  @override
  ConsumerState<NewExpenseSheet> createState() => _NewExpenseSheetState();
}

class _NewExpenseSheetState extends ConsumerState<NewExpenseSheet> {
  String _amount = '';
  TransactionType _type = TransactionType.expense;
  String? _category;
  TransactionMethod? _method;
  DateTime? _date;
  late final TextEditingController _label =
      TextEditingController(text: widget.initialLabel ?? '');
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    final amountMinor = widget.initialAmountMinor;
    if (amountMinor != null && amountMinor > 0) {
      _amount = amountFieldText(amountMinor);
    }
    unawaited(_loadLastMethod());
  }

  @override
  void dispose() {
    _label.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadLastMethod() async {
    final last = await ref.read(transactionRepositoryProvider).lastMethod();
    if (mounted && last != null) setState(() => _method = last);
  }

  DateTime get _effectiveDate => _date ?? ref.read(clockProvider).today();

  bool get _canSave => parseAmountMinor(_amount) > 0;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null && mounted) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save() async {
    final amountMinor = parseAmountMinor(_amount);
    if (amountMinor <= 0) return;

    final repository = ref.read(transactionRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final type = _type;
    final label = _label.text.trim();
    final note = _note.text.trim();

    final draft = NewTransaction(
      amountMinor: amountMinor,
      type: type,
      date: _effectiveDate,
      category: _category,
      method: _method,
      label: label.isEmpty ? null : label,
      note: note.isEmpty ? null : note,
      billId: widget.billId,
      spaceId: widget.spaceId,
      vehicleId: widget.vehicleId,
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
    final categories = ref.watch(
      categoriesOfKindProvider(categoryKindFor(_type)),
    );

    return SheetScaffold(
      title: _type == TransactionType.expense ? 'New expense' : 'New income',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KoshaChip(
              label: 'Expense',
              selected: _type == TransactionType.expense,
              onTap: () => setState(() {
                _type = TransactionType.expense;
                _category = null;
              }),
            ),
            const SizedBox(width: 8),
            KoshaChip(
              label: 'Income',
              selected: _type == TransactionType.income,
              onTap: () => setState(() {
                _type = TransactionType.income;
                _category = null;
              }),
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
        const SizedBox(height: 14),
        const _FieldLabel('Date'),
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
        const _FieldLabel('Category'),
        const SizedBox(height: 8),
        categories.when(
          loading: () => const SizedBox(height: 34),
          error: (_, _) => Text(
            'Categories unavailable',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
          data: (list) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in list)
                KoshaChip(
                  label: category.name,
                  icon: categoryIcon(category.iconKey),
                  selected: _category == category.name,
                  onTap: () => setState(
                    () => _category =
                        _category == category.name ? null : category.name,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _FieldLabel('Method'),
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
        const SizedBox(height: 14),
        TextField(
          controller: _label,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'What was it for? (optional)',
          ),
        ),
        const SizedBox(height: 10),
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
        if (!_canSave) ...[
          const SizedBox(height: 8),
          Text(
            'Enter an amount greater than zero.',
            style: t.bodySmall?.copyWith(color: c.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

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
