import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/home/data/task_upcoming_source.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  test('only open tasks strictly inside the window are returned', () async {
    final repository = testRepository(db, now: testNow);
    await repository.create(NewTask(title: 'Today', dueDate: testToday));
    final inside = await repository.create(
      NewTask(title: 'Next week', dueDate: DateTime(2026, 9, 8)),
    );
    final done = await repository.create(
      NewTask(title: 'Done', dueDate: DateTime(2026, 9, 8)),
    );
    await repository.setDone(done.id, done: true);
    await repository.create(NewTask(title: 'Far future', dueDate: DateTime(2026, 10, 1)));

    final source = TaskUpcomingSource(repository);
    final items = await source
        .watch(from: DateTime(2026, 9, 5), to: DateTime(2026, 9, 12))
        .first;

    expect(items.map((i) => i.id), [inside.id]);
    expect(items.single.title, 'Next week');
    expect(items.single.date, DateTime(2026, 9, 8));
  });
}
