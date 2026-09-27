import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/home_management_repository_impl.dart';
import '../../domain/entities/maintenance_job.dart';

/// Add and edit share one sheet — section 6.10 names only "Add maintenance
/// job" as a screen, so editing an existing job reopens the same fields
/// rather than a second one.
Future<void> showMaintenanceJobSheet(
  BuildContext context, {
  MaintenanceJob? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => MaintenanceJobSheet(existing: existing),
  );
}

class MaintenanceJobSheet extends ConsumerStatefulWidget {
  const MaintenanceJobSheet({super.key, this.existing});

  final MaintenanceJob? existing;

  @override
  ConsumerState<MaintenanceJobSheet> createState() =>
      _MaintenanceJobSheetState();
}

class _MaintenanceJobSheetState extends ConsumerState<MaintenanceJobSheet> {
  late final TextEditingController _title =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _vendor =
      TextEditingController(text: widget.existing?.vendor ?? '');
  late final TextEditingController _notes =
      TextEditingController(text: widget.existing?.notes ?? '');
  late final TextEditingController _cost = TextEditingController(
    text: widget.existing?.costMinor == null
        ? ''
        : amountFieldText(widget.existing!.costMinor!),
  );
  late DateTime? _dueDate = widget.existing?.dueDate;
  late MaintenanceJobStatus _status =
      widget.existing?.status ?? MaintenanceJobStatus.upcoming;

  @override
  void initState() {
    super.initState();
    for (final controller in [_title, _vendor, _notes, _cost]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _vendor.dispose();
    _notes.dispose();
    _cost.dispose();
    super.dispose();
  }

  bool get _canSave => _title.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: DateTime(today.year - 2),
      lastDate: DateTime(today.year + 10),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(homeManagementRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final title = _title.text.trim();
    final vendor = _vendor.text.trim();
    final notes = _notes.text.trim();
    final costMinor = parseAmountMinor(_cost.text);

    Navigator.of(context).pop();

    final existing = widget.existing;
    if (existing == null) {
      await repository.createJob(
        NewMaintenanceJob(
          title: title,
          status: _status,
          dueDate: _dueDate,
          costMinor: costMinor == 0 ? null : costMinor,
          vendor: vendor.isEmpty ? null : vendor,
          notes: notes.isEmpty ? null : notes,
        ),
      );
      toast.show('Added “$title”');
    } else {
      await repository.editJob(
        existing.id,
        title: title,
        status: _status,
        dueDate: _dueDate,
        clearDueDate: _dueDate == null,
        costMinor: costMinor == 0 ? null : costMinor,
        clearCost: costMinor == 0,
        vendor: vendor.isEmpty ? null : vendor,
        clearVendor: vendor.isEmpty,
        notes: notes.isEmpty ? null : notes,
        clearNotes: notes.isEmpty,
      );
      toast.show('Saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    final due = _dueDate;

    return SheetScaffold(
      title: widget.existing == null ? 'Add maintenance job' : 'Edit job',
      children: [
        TextField(
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'e.g. AC service'),
        ),
        const SizedBox(height: 16),
        const _Label('Status'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final status in const [
              MaintenanceJobStatus.upcoming,
              MaintenanceJobStatus.active,
              MaintenanceJobStatus.done,
            ])
              KoshaChip(
                label: status.label,
                selected: _status == status,
                onTap: () => setState(() => _status = status),
              ),
          ],
        ),
        const SizedBox(height: 16),
        const _Label('Due date (optional)'),
        const SizedBox(height: 8),
        Row(
          children: [
            KoshaChip(
              label: due == null ? 'No date' : Dates.dayMonthYear(due),
              icon: Symbols.event_rounded,
              selected: false,
              onTap: () => unawaited(_pickDate()),
            ),
            if (due != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Clear date',
                icon: const Icon(Symbols.close_rounded, size: 18),
                onPressed: () => setState(() => _dueDate = null),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _vendor,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Vendor (optional)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cost,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            prefixText: '₹ ',
            hintText: 'Cost (optional)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notes,
          textInputAction: TextInputAction.done,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Notes (optional)'),
        ),
        const SizedBox(height: 16),
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
                child: Text(widget.existing == null ? 'Add' : 'Save changes'),
              ),
            ),
          ],
        ),
      ],
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
