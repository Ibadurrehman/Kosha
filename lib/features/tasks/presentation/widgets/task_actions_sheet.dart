import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../domain/entities/task.dart';
import 'sheet_scaffold.dart';

/// What the "•••" sheet can do to a task.
enum TaskAction { complete, reschedule, openDetails, duplicate, delete }

/// Returns the action the user picked, or null if the sheet was dismissed.
Future<TaskAction?> showTaskActionsSheet(
  BuildContext context, {
  required Task task,
  bool showOpenDetails = true,
}) {
  return showModalBottomSheet<TaskAction>(
    context: context,
    useSafeArea: true,
    builder: (_) => _TaskActionsSheet(task: task, showOpenDetails: showOpenDetails),
  );
}

class _TaskActionsSheet extends StatelessWidget {
  const _TaskActionsSheet({required this.task, required this.showOpenDetails});

  final Task task;
  final bool showOpenDetails;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return SheetScaffold(
      title: task.title,
      children: [
        _Action(
          icon: task.done
              ? Symbols.replay_rounded
              : Symbols.check_circle_rounded,
          label: task.done ? 'Move back to open' : 'Complete',
          onTap: () => Navigator.of(context).pop(TaskAction.complete),
        ),
        _Action(
          icon: Symbols.event_repeat_rounded,
          label: 'Reschedule',
          onTap: () => Navigator.of(context).pop(TaskAction.reschedule),
        ),
        if (showOpenDetails)
          _Action(
            icon: Symbols.open_in_full_rounded,
            label: 'Open details',
            onTap: () => Navigator.of(context).pop(TaskAction.openDetails),
          ),
        _Action(
          icon: Symbols.content_copy_rounded,
          label: 'Duplicate',
          onTap: () => Navigator.of(context).pop(TaskAction.duplicate),
        ),
        _Action(
          icon: Symbols.delete_rounded,
          label: 'Delete',
          tone: c.error,
          onTap: () => Navigator.of(context).pop(TaskAction.delete),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final color = tone ?? c.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
