import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/task.dart';
import 'sheet_scaffold.dart';

/// The four reschedule presets from the prototype.
enum RescheduleChoice { laterToday, tomorrow, nextWeek, pickDate }

Future<RescheduleChoice?> showRescheduleSheet(
  BuildContext context, {
  required Task task,
}) {
  return showModalBottomSheet<RescheduleChoice>(
    context: context,
    useSafeArea: true,
    builder: (_) => _RescheduleSheet(task: task),
  );
}

class _RescheduleSheet extends ConsumerWidget {
  const _RescheduleSheet({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.read(clockProvider).today();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final nextWeek = DateTime(today.year, today.month, today.day + 7);
    final due = task.dueDate;

    return SheetScaffold(
      title: 'Reschedule',
      subtitle: due == null
          ? 'No date yet'
          : 'Currently ${Dates.dayMonth(due)}',
      children: [
        _Option(
          icon: Symbols.schedule_rounded,
          label: 'Later today',
          trailing: Dates.minuteOfDay(20 * 60),
          onTap: () => Navigator.of(context).pop(RescheduleChoice.laterToday),
        ),
        _Option(
          icon: Symbols.today_rounded,
          label: 'Tomorrow',
          trailing: Dates.dayMonth(tomorrow),
          onTap: () => Navigator.of(context).pop(RescheduleChoice.tomorrow),
        ),
        _Option(
          icon: Symbols.next_week_rounded,
          label: 'Next week',
          trailing: Dates.dayMonth(nextWeek),
          onTap: () => Navigator.of(context).pop(RescheduleChoice.nextWeek),
        ),
        _Option(
          icon: Symbols.edit_calendar_rounded,
          label: 'Pick a date',
          onTap: () => Navigator.of(context).pop(RescheduleChoice.pickDate),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 21, color: c.text),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: t.titleMedium)),
            if (trailing != null) Text(trailing!, style: t.bodySmall),
          ],
        ),
      ),
    );
  }
}
