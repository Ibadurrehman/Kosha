import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/bill_repository_impl.dart';
import '../domain/entities/bill.dart';
import 'controllers/bill_providers.dart';
import 'widgets/bill_form.dart';

/// Edits one bill with the same fields the New bill sheet collects.
class BillEditScreen extends ConsumerWidget {
  const BillEditScreen({super.key, required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billByIdProvider(billId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit bill')),
      body: bill.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this bill",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(billByIdProvider(billId)),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This bill is gone',
                body: 'It was deleted while you were editing it.',
                actionLabel: 'Back',
                onAction: () => context.pop(),
              )
            // Keyed on the row's identity so the form is built once from the
            // loaded values, never rebuilt out from under the user by a later
            // emission of the same stream.
            : _Form(key: ValueKey(value.id), bill: value),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({super.key, required this.bill});

  final Bill bill;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final BillFormController _form = BillFormController(
    today: ref.read(clockProvider).today(),
    bill: widget.bill,
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

    // A bill that had no date and now has one is setting a reminder for the
    // first time, which is the moment to ask — same rule as the task editor.
    if (widget.bill.nextDue == null && draft.nextDue != null) {
      unawaited(scheduler.requestPermission());
    }

    await repository.save(
      widget.bill.copyWith(
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
    if (!mounted) return;
    toast.show('Saved');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
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
            children: [BillFormFields(controller: _form)],
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
                      onPressed: _form.isValid ? () => unawaited(_save()) : null,
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
