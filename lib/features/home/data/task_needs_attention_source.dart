import '../../tasks/domain/entities/task.dart';
import '../../tasks/domain/task_repository.dart';
import '../domain/entities/home_item_kind.dart';
import '../domain/entities/needs_attention_item.dart';
import '../domain/needs_attention_source.dart';

/// Overdue tasks — the only "needs attention" source until Bills and
/// Documents exist (Phase 2/3).
class TaskNeedsAttentionSource implements NeedsAttentionSource {
  TaskNeedsAttentionSource(this._tasks);

  final TaskRepository _tasks;

  @override
  Stream<List<NeedsAttentionItem>> watch({required DateTime today}) {
    return _tasks.watchBucket(TaskBucket.overdue, today: today).map(
          (tasks) => [
            for (final task in tasks)
              NeedsAttentionItem(
                id: task.id,
                kind: HomeItemKind.task,
                title: task.title,
                subtitle: _overdueBy(task, today),
                ctaLabel: 'View',
              ),
          ],
        );
  }

  String _overdueBy(Task task, DateTime today) {
    final due = task.dueDate;
    if (due == null) return 'Overdue';
    final days = today.difference(due).inDays;
    return days <= 1 ? 'Overdue since yesterday' : 'Overdue by $days days';
  }
}
