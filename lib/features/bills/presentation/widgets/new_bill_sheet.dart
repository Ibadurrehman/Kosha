import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/notifications/reminder_scheduler.dart';
import '../../../../core/utils/clock.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/bill_repository_impl.dart';
import '../../domain/entities/bill.dart';
import 'bill_form.dart';

/// Opens the New bill sheet — Quick add's "Bill" tile and the Bills screen's
/// own FAB both land here.
Future<void> showNewBillSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewBillSheet(),
  );
}

class NewBillSheet extends ConsumerStatefulWidget {
  const NewBillSheet({super.key});

  @override
  ConsumerState<NewBillSheet> createState() => _NewBillSheetState();
}

class _NewBillSheetState extends ConsumerState<NewBillSheet> {
  late final BillFormController _form = BillFormController(
    today: ref.read(clockProvider).today(),
  )..addListener(_onChanged);

  @override
  void dispose() {
    _form
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _save() async {
    if (!_form.isValid) return;

    final repository = ref.read(billRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final scheduler = ref.read(reminderSchedulerProvider);
    final draft = _form.toDraft();

    Navigator.of(context).pop();
    // Permission is asked for at the moment a reminder is first set, not on
    // launch — the same rule the task sheets follow. A dateless bill reminds
    // about nothing, so it never prompts.
    if (draft.nextDue != null) unawaited(scheduler.requestPermission());

    final bill = await repository.create(
      NewBill(
        name: draft.name,
        amountMinor: draft.amountMinor,
        kind: draft.kind,
        nextDue: draft.nextDue,
        frequencyRule: draft.frequencyRule,
        autopay: draft.autopay,
        reminderOffsetDays: draft.reminderOffsetDays,
        provider: draft.provider,
        accountRef: draft.accountRef,
        notes: draft.notes,
      ),
    );
    toast.show(
      'Added “${bill.name}”',
      onUndo: () => unawaited(repository.purge(bill.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'New bill',
      children: [
        BillFormFields(controller: _form),
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
                onPressed: _form.isValid ? () => unawaited(_save()) : null,
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
