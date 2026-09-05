import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../shared/widgets/priority_dot.dart';
import '../../domain/entities/task.dart';
import '../task_labels.dart';

/// Identifies the completion checkbox inside a [TaskRow] for widget tests.
const Key taskCheckboxKey = Key('task-checkbox');

/// One task in a list: checkbox, title, meta line and priority dot.
///
/// [onOpen] is left null until the task detail screen lands, so the row has no
/// dead tap target in the meantime.
class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.task,
    required this.today,
    required this.onToggle,
    this.onOpen,
    this.trailing,
  });

  final Task task;
  final DateTime today;
  final VoidCallback onToggle;
  final VoidCallback? onOpen;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Opacity(
      opacity: task.done ? 0.55 : 1,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoshaRadius.row),
          side: BorderSide(color: c.border),
        ),
        child: Row(
          children: [
            _Checkbox(
              key: taskCheckboxKey,
              done: task.done,
              onTap: onToggle,
            ),
            Expanded(
              child: InkWell(
                onTap: onOpen,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: t.titleMedium?.copyWith(
                          color: task.done ? c.text2 : c.text,
                          decoration:
                              task.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(taskMetaLine(task, today), style: t.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
            PriorityDot(task.priority),
            SizedBox(width: trailing == null ? 14 : 6),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// 22 px box inside a 44 px tap target, so the row stays compact without
/// dropping below the minimum touch size.
class _Checkbox extends StatelessWidget {
  const _Checkbox({super.key, required this.done, required this.onTap});

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Semantics(
      checked: done,
      label: 'Toggle task complete',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: done ? c.accent : Colors.transparent,
                border: Border.all(color: done ? c.accent : c.border, width: 2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: done
                  ? const Icon(
                      Symbols.check_rounded,
                      size: 14,
                      weight: 700,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
