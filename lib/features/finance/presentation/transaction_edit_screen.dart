import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/transaction_repository_impl.dart';
import '../domain/entities/transaction.dart';
import 'category_icons.dart';
import 'controllers/finance_providers.dart';
import 'transaction_labels.dart';

/// Edits one transaction — the same fields the New expense sheet collects,
/// laid out as a screen because an editor is somewhere you stay, not
/// something you flick up.
class TransactionEditScreen extends ConsumerWidget {
  const TransactionEditScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit transaction')),
      body: transaction.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this transaction",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(transactionByIdProvider(transactionId)),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This transaction is gone',
                body: 'It was deleted while you were editing it.',
                actionLabel: 'Back',
                onAction: () => context.pop(),
              )
            // Keyed on the row's identity so the form is built once from the
            // loaded values and never rebuilt out from under the user by a
            // later emission of the same stream.
            : _Form(key: ValueKey(value.id), transaction: value),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({super.key, required this.transaction});

  final Transaction transaction;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late String _amount = amountFieldText(widget.transaction.amountMinor);
  late TransactionType _type = widget.transaction.type;
  late String? _category = widget.transaction.category;
  late TransactionMethod? _method = widget.transaction.method;
  late DateTime _date = widget.transaction.date;
  late final TextEditingController _label =
      TextEditingController(text: widget.transaction.label ?? '');
  late final TextEditingController _note =
      TextEditingController(text: widget.transaction.note ?? '');

  @override
  void dispose() {
    _label.dispose();
    _note.dispose();
    super.dispose();
  }

  bool get _canSave => parseAmountMinor(_amount) > 0;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
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
    final label = _label.text.trim();
    final note = _note.text.trim();

    await repository.save(
      widget.transaction.copyWith(
        amountMinor: amountMinor,
        type: _type,
        date: _date,
        category: _category,
        method: _method,
        label: label.isEmpty ? null : label,
        note: note.isEmpty ? null : note,
      ),
    );
    if (!mounted) return;
    toast.show('Saved');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final categories = ref.watch(
      categoriesOfKindProvider(categoryKindFor(_type)),
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              12,
              KoshaSpace.screen,
              24,
            ),
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
              const SizedBox(height: 16),
              const SectionLabel('Date'),
              Align(
                alignment: Alignment.centerLeft,
                child: KoshaChip(
                  label: Dates.dayMonthYear(_date),
                  icon: Symbols.event_rounded,
                  selected: false,
                  onTap: () => unawaited(_pickDate()),
                ),
              ),
              const SizedBox(height: 16),
              const SectionLabel('Category'),
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
                          () => _category = _category == category.name
                              ? null
                              : category.name,
                        ),
                      ),
                    // A category the user has since deleted still names this
                    // transaction, so it stays offered here rather than
                    // silently clearing itself on the next save.
                    if (_category != null &&
                        !list.any((item) => item.name == _category))
                      KoshaChip(
                        label: _category!,
                        selected: true,
                        onTap: () => setState(() => _category = null),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SectionLabel('Method'),
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
              const SizedBox(height: 16),
              TextField(
                controller: _label,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'What was it for?',
                  hintText: 'Optional',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Optional',
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: context.pop,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _canSave ? () => unawaited(_save()) : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
