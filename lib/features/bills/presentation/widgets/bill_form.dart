import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/recurrence/recurrence.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../../shared/widgets/kosha_toggle.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../domain/entities/bill.dart';
import '../bill_labels.dart';

/// Everything the New bill sheet and the Edit bill screen collect. Kept in
/// one widget so the two can never fall out of step — the sheet wraps it in
/// `SheetScaffold`, the screen in a `Scaffold`, and both hand back the same
/// [BillDraft].
class BillDraft {
  const BillDraft({
    required this.name,
    required this.amountMinor,
    required this.kind,
    required this.nextDue,
    required this.frequencyRule,
    required this.autopay,
    required this.reminderOffsetDays,
    this.provider,
    this.accountRef,
    this.notes,
  });

  final String name;
  final int amountMinor;
  final BillKind kind;
  final DateTime? nextDue;
  final String? frequencyRule;
  final bool autopay;
  final int reminderOffsetDays;
  final String? provider;
  final String? accountRef;
  final String? notes;
}

/// The form's live state, lifted so the host can drive its own Save button.
class BillFormController extends ChangeNotifier {
  BillFormController({required DateTime today, Bill? bill})
      : name = TextEditingController(text: bill?.name ?? ''),
        amount = TextEditingController(
          text: bill == null ? '' : amountFieldText(bill.amountMinor),
        ),
        provider = TextEditingController(text: bill?.provider ?? ''),
        accountRef = TextEditingController(text: bill?.accountRef ?? ''),
        notes = TextEditingController(text: bill?.notes ?? ''),
        kind = bill?.kind ?? BillKind.bill,
        // A new bill defaults to next month's same day, which is what a bill
        // being entered almost always means; an existing one keeps its date,
        // including the null a settled one-off has.
        nextDue = bill == null
            ? DateTime(today.year, today.month + 1, today.day)
            : bill.nextDue,
        preset = bill == null
            ? RecurrencePreset.monthly
            : Recurrence.presetOf(bill.frequencyRule),
        autopay = bill?.autopay ?? false,
        reminderOffsetDays = bill?.reminderOffsetDays ?? defaultBillReminderDays {
    name.addListener(notifyListeners);
    amount.addListener(notifyListeners);
  }

  final TextEditingController name;
  final TextEditingController amount;
  final TextEditingController provider;
  final TextEditingController accountRef;
  final TextEditingController notes;

  BillKind kind;
  DateTime? nextDue;
  RecurrencePreset preset;
  bool autopay;
  int reminderOffsetDays;

  /// Both a name and a real amount, the same two-field gate the New task
  /// sheet and the expense sheet each apply to their own required field.
  bool get isValid =>
      name.text.trim().isNotEmpty && parseAmountMinor(amount.text) > 0;

  BillDraft toDraft() {
    final due = nextDue;
    return BillDraft(
      name: name.text.trim(),
      amountMinor: parseAmountMinor(amount.text),
      kind: kind,
      nextDue: due,
      frequencyRule: Recurrence.ruleFor(preset, start: due),
      autopay: autopay,
      reminderOffsetDays: reminderOffsetDays,
      provider: _trimmed(provider),
      accountRef: _trimmed(accountRef),
      notes: _trimmed(notes),
    );
  }

  void set(void Function() change) {
    change();
    notifyListeners();
  }

  static String? _trimmed(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    provider.dispose();
    accountRef.dispose();
    notes.dispose();
    super.dispose();
  }
}

/// The fields themselves, as a list the host drops into its own scroller.
class BillFormFields extends ConsumerWidget {
  const BillFormFields({super.key, required this.controller});

  final BillFormController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final due = controller.nextDue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.name,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Name, e.g. Electricity'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            prefixText: '₹ ',
            hintText: 'Amount',
          ),
        ),
        const SizedBox(height: 16),
        const _Label('Kind'),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final kind in BillKind.values) ...[
              KoshaChip(
                label: kind.label,
                selected: controller.kind == kind,
                onTap: () => controller.set(() => controller.kind = kind),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _Label(
          controller.kind == BillKind.subscription ? 'Renews on' : 'Due on',
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            KoshaChip(
              label: due == null ? 'No date' : Dates.dayMonthYear(due),
              icon: Symbols.event_rounded,
              selected: false,
              onTap: () => unawaited(_pickDate(context, ref)),
            ),
            if (due != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Clear date',
                icon: const Icon(Symbols.close_rounded, size: 18),
                onPressed: () => controller.set(() => controller.nextDue = null),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const _Label('Frequency'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in billFrequencyPresets)
              KoshaChip(
                label: billFrequencyPresetLabel(preset),
                selected: controller.preset == preset,
                onTap: () => controller.set(() => controller.preset = preset),
              ),
          ],
        ),
        const SizedBox(height: 16),
        const _Label('Remind me'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final days in billReminderChoices)
              KoshaChip(
                label: billReminderLabel(days),
                selected: controller.reminderOffsetDays == days,
                onTap: () =>
                    controller.set(() => controller.reminderOffsetDays = days),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Autopay'),
          subtitle: const Text('It leaves your account on its own'),
          trailing: KoshaToggle(
            value: controller.autopay,
            semanticLabel: 'Autopay',
            onChanged: (value) =>
                controller.set(() => controller.autopay = value),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller.provider,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'Provider (optional)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.accountRef,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'Account or consumer number (optional)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.notes,
          textInputAction: TextInputAction.done,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Notes (optional)'),
        ),
        if (controller.nextDue == null) ...[
          const SizedBox(height: 10),
          Text(
            'Without a date this bill never reminds you and never counts '
            'towards what you owe.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.nextDue ?? today,
      firstDate: DateTime(today.year - 2),
      lastDate: DateTime(today.year + 10),
    );
    if (picked == null) return;
    controller.set(
      () => controller.nextDue = DateTime(picked.year, picked.month, picked.day),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

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
