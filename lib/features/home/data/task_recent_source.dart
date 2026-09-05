import '../../../core/utils/formatters.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/domain/task_repository.dart';
import '../domain/entities/home_item_kind.dart';
import '../domain/entities/recent_item.dart';
import '../domain/recent_source.dart';

/// Recently created/updated tasks — the only "recent" source until other
/// entity types exist.
class TaskRecentSource implements RecentSource {
  TaskRecentSource(this._tasks);

  final TaskRepository _tasks;

  @override
  Stream<List<RecentItem>> watch({required int limit}) {
    return _tasks.watchRecent(limit: limit).map(
          (tasks) => [
            for (final task in tasks)
              RecentItem(
                id: task.id,
                kind: HomeItemKind.task,
                title: task.title,
                subtitle: _subtitle(task),
                at: task.updatedAt,
              ),
          ],
        );
  }

  String _subtitle(Task task) {
    if (task.done) return 'Completed';
    final due = task.dueDate;
    return due == null ? 'No date' : 'Due ${Dates.dayMonth(due)}';
  }
}
