import '../../tasks/domain/task_repository.dart';
import '../domain/entities/home_item_kind.dart';
import '../domain/entities/upcoming_item.dart';
import '../domain/upcoming_source.dart';

/// Tasks due in the window — the only "upcoming" source until Bills,
/// renewals and Events (this same phase, once the Calendar work adds them)
/// join in.
class TaskUpcomingSource implements UpcomingSource {
  TaskUpcomingSource(this._tasks);

  final TaskRepository _tasks;

  @override
  Stream<List<UpcomingItem>> watch({
    required DateTime from,
    required DateTime to,
  }) {
    return _tasks.watchDueBetween(from, to).map(
          (tasks) => [
            for (final task in tasks)
              UpcomingItem(
                id: task.id,
                kind: HomeItemKind.task,
                title: task.title,
                date: task.dueDate!,
              ),
          ],
        );
  }
}
