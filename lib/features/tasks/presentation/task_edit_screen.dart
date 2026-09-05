import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/priority.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/task_repository_impl.dart';
import '../domain/entities/task.dart';
import 'controllers/task_providers.dart';
import 'task_labels.dart';

/// The full editor behind the detail screen's Edit button.
class TaskEditScreen extends ConsumerWidget {
  const TaskEditScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskByIdProvider(taskId));
    return Scaffold(
      appBar: AppBar(title: const Text('Edit task')),
      body: task.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this task",
          body: 'Something went wrong reading the database.',
        ),
        // Keyed so the form rebuilds from scratch if the task is swapped out.
        data: (value) => value == null
            ? const EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This task is gone',
                body: 'It was deleted while you were editing.',
              )
            : _EditForm(key: ValueKey(value.id), task: value),
      ),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final TextEditingController _title =
      TextEditingController(text: widget.task.title);
  late final TextEditingController _description =
      TextEditingController(text: widget.task.description ?? '');
  late final TextEditingController _category =
      TextEditingController(text: widget.task.category ?? '');

  late DateTime? _dueDate = widget.task.dueDate;
  late int? _dueMinutes = widget.task.dueMinutes;
  late Priority _priority = widget.task.priority;
  late RecurrencePreset _repeat =
      Recurrence.presetOf(widget.task.recurrenceRule);
  late int? _reminder = widget.task.reminderOffsetMinutes;

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    super.dispose();
  }

  bool get _canSave => _title.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final current = _dueMinutes ?? 9 * 60;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked != null) {
      setState(() => _dueMinutes = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _save() async {
    final repository = ref.read(taskRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final category = _category.text.trim();

    // Ask only when a reminder was newly asked for.
    if (_reminder != null && widget.task.reminderOffsetMinutes == null) {
      await ref.read(reminderSchedulerProvider).requestPermission();
      if (!mounted) return;
    }

    final updated = widget.task.copyWith(
      title: _title.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      dueDate: _dueDate,
      // A time without a date has nothing to fire against.
      dueMinutes: _dueDate == null ? null : _dueMinutes,
      priority: _priority,
      recurrenceRule: Recurrence.ruleFor(_repeat, start: _dueDate),
      reminderOffsetMinutes: _reminder,
      category: category.isEmpty ? null : category,
    );

    await repository.save(updated);
    toast.show('Saved “${updated.title}”');
    if (mounted) context.pop();
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
              8,
              KoshaSpace.screen,
              24,
            ),
            children: [
              const SectionLabel('Title'),
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  hintText: 'What needs doing?',
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel('Notes'),
              TextField(
                controller: _description,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Anything worth remembering',
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel('When'),
              _PickerRow(
                icon: Symbols.event_rounded,
                label: 'Due date',
                value: _dueDate == null
                    ? 'Not set'
                    : Dates.dayMonthYear(_dueDate!),
                onTap: () => unawaited(_pickDate()),
                onClear:
                    _dueDate == null ? null : () => setState(() => _dueDate = null),
              ),
              Divider(height: 1, color: c.hair),
              _PickerRow(
                icon: Symbols.schedule_rounded,
                label: 'Time',
                value: _dueMinutes == null
                    ? 'Any time'
                    : Dates.minuteOfDay(_dueMinutes!),
                enabled: _dueDate != null,
                onTap: () => unawaited(_pickTime()),
                onClear: _dueMinutes == null
                    ? null
                    : () => setState(() => _dueMinutes = null),
              ),
              const SizedBox(height: 20),
              const SectionLabel('Priority'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in Priority.values)
                    KoshaChip(
                      label: option.label,
                      selected: _priority == option,
                      onTap: () => setState(() => _priority = option),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const SectionLabel('Repeat'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in RecurrencePreset.values)
                    KoshaChip(
                      label: option.label,
                      selected: _repeat == option,
                      onTap: () => setState(() => _repeat = option),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const SectionLabel('Reminder'),
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
              const SizedBox(height: 20),
              const SectionLabel('Category'),
              TextField(
                controller: _category,
                decoration: const InputDecoration(hintText: 'Inbox'),
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
              child: FilledButton(
                onPressed: _canSave ? () => unawaited(_save()) : null,
                child: const Text('Save changes'),
              ),
            ),
          ),
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
    this.onClear,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 19, color: enabled ? c.text3 : c.disabled),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: t.bodySmall?.copyWith(
                  color: enabled ? c.text2 : c.disabled,
                ),
              ),
            ),
            Text(
              value,
              style: t.titleSmall?.copyWith(
                color: enabled ? c.text : c.disabled,
              ),
            ),
            if (onClear != null && enabled)
              IconButton(
                tooltip: 'Clear $label',
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Symbols.close_rounded),
                onPressed: onClear,
              ),
          ],
        ),
      ),
    );
  }
}
