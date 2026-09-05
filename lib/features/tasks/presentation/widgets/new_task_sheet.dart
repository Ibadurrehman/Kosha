import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/models/priority.dart';
import '../../../../core/services/notifications/reminder_scheduler.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../data/task_repository_impl.dart';
import '../../domain/entities/task.dart';

/// Opens the quick "New task" sheet.
Future<void> showNewTaskSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewTaskSheet(),
  );
}

/// Title plus four shortcuts, matching the prototype. A full editor with dates,
/// reminders and repeat rules arrives in week 2.
class NewTaskSheet extends ConsumerStatefulWidget {
  const NewTaskSheet({super.key});

  @override
  ConsumerState<NewTaskSheet> createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends ConsumerState<NewTaskSheet> {
  final TextEditingController _title = TextEditingController();
  bool _dueToday = true;
  bool _remindMe = false;
  bool _high = false;
  bool _repeats = false;

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  bool get _canCreate => _title.text.trim().isNotEmpty;

  Future<void> _create() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    // Read everything before popping: the sheet's ref dies with the route.
    final repository = ref.read(taskRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final today = ref.read(clockProvider).today();

    // Ask the first time a reminder is actually wanted, rather than at launch.
    if (_remindMe) {
      await ref.read(reminderSchedulerProvider).requestPermission();
      if (!mounted) return;
    }

    final draft = NewTask(
      title: title,
      dueDate: _dueToday ? today : null,
      priority: _high ? Priority.high : Priority.none,
      recurrenceRule: _repeats ? 'FREQ=DAILY' : null,
      reminderOffsetMinutes: _remindMe ? 0 : null,
    );

    Navigator.of(context).pop();
    final task = await repository.create(draft);
    toast.show(
      '“${task.title}” added to ${task.bucketOn(today).label}',
      onUndo: () => unawaited(repository.purge(task.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('New task', style: t.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: _title,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => unawaited(_create()),
              decoration: const InputDecoration(
                hintText: 'What needs doing?',
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                KoshaChip(
                  label: 'Today',
                  icon: Symbols.event_rounded,
                  selected: _dueToday,
                  onTap: () => setState(() => _dueToday = !_dueToday),
                ),
                KoshaChip(
                  label: 'Remind me',
                  icon: Symbols.notifications_rounded,
                  selected: _remindMe,
                  onTap: () => setState(() => _remindMe = !_remindMe),
                ),
                KoshaChip(
                  label: 'High',
                  icon: Symbols.flag_rounded,
                  selected: _high,
                  onTap: () => setState(() => _high = !_high),
                ),
                KoshaChip(
                  label: 'Repeat',
                  icon: Symbols.repeat_rounded,
                  selected: _repeats,
                  onTap: () => setState(() => _repeats = !_repeats),
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
                    child: const Text('Create task'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
