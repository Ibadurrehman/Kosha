import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/notifications/reminder_scheduler.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../tasks/presentation/task_labels.dart' show reminderLabel, reminderOffsetOptions;
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/event_repository_impl.dart';
import '../../domain/entities/event.dart';

/// Opens the "New event" sheet, reached from Quick add → Reminder (gap G6/G7:
/// a reminder with a time is an event).
Future<void> showNewEventSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewEventSheet(),
  );
}

class NewEventSheet extends ConsumerStatefulWidget {
  const NewEventSheet({super.key});

  @override
  ConsumerState<NewEventSheet> createState() => _NewEventSheetState();
}

class _NewEventSheetState extends ConsumerState<NewEventSheet> {
  final TextEditingController _title = TextEditingController();
  DateTime? _date;
  int? _minutes = 9 * 60;
  int? _reminder;

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
    // "Today" is the sheet's default, same as the task quick-add.
    final today = ref.read(clockProvider).today();
    _date = today;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  bool get _canCreate => _title.text.trim().isNotEmpty && _date != null;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final current = _minutes ?? 9 * 60;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked != null) {
      setState(() => _minutes = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _create() async {
    final date = _date;
    final title = _title.text.trim();
    if (title.isEmpty || date == null) return;

    final repository = ref.read(eventRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final minutes = _minutes ?? 0;
    final startAt = DateTime(date.year, date.month, date.day, minutes ~/ 60, minutes % 60);

    if (_reminder != null) {
      await ref.read(reminderSchedulerProvider).requestPermission();
      if (!mounted) return;
    }

    final draft = NewEvent(
      title: title,
      startAt: startAt,
      reminderOffsetMinutes: _reminder,
    );

    Navigator.of(context).pop();
    final event = await repository.create(draft);
    toast.show(
      '“${event.title}” added to your calendar',
      onUndo: () => unawaited(repository.purge(event.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return SheetScaffold(
      title: 'New event',
      children: [
        TextField(
          controller: _title,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Doctor, gym, flight…'),
        ),
        const SizedBox(height: 14),
        _PickerRow(
          icon: Symbols.event_rounded,
          label: 'Date',
          value: _date == null ? 'Not set' : Dates.dayMonthYear(_date!),
          onTap: () => unawaited(_pickDate()),
        ),
        Divider(height: 1, color: c.hair),
        _PickerRow(
          icon: Symbols.schedule_rounded,
          label: 'Time',
          value: Dates.minuteOfDay(_minutes ?? 9 * 60),
          onTap: () => unawaited(_pickTime()),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in reminderOffsetOptions)
              KoshaChip(
                label: reminderLabel(option),
                selected: _reminder == option,
                onTap: () => setState(() => _reminder = option),
              ),
          ],
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
                onPressed: _canCreate ? () => unawaited(_create()) : null,
                child: const Text('Create event'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 19, color: c.text3),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: t.bodySmall)),
            Text(value, style: t.titleSmall),
          ],
        ),
      ),
    );
  }
}
