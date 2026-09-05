import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/home/data/task_recent_source.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  test('newest-first, any status, respects the limit', () async {
    final repository = testRepository(db, now: testNow);
    final first = await repository.create(const NewTask(title: 'First'));
    final laterRepository = testRepository(
      db,
      now: testNow.add(const Duration(minutes: 1)),
    );
    final second = await laterRepository.create(const NewTask(title: 'Second'));
    await laterRepository.setDone(second.id, done: true);

    final source = TaskRecentSource(repository);
    final items = await source.watch(limit: 10).first;

    expect(items.map((i) => i.id), [second.id, first.id]);
    expect(items.first.subtitle, 'Completed');
    expect(items.last.subtitle, 'No date');
  });

  test('a due task subtitle names the date', () async {
    final repository = testRepository(db, now: testNow);
    await repository.create(NewTask(title: 'Renew passport', dueDate: DateTime(2026, 9, 20)));

    final items = await TaskRecentSource(repository).watch(limit: 10).first;
    expect(items.single.subtitle, 'Due 20 Sep');
  });
}
