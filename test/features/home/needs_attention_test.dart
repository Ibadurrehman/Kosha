import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/home/data/task_needs_attention_source.dart';
import 'package:kosha/features/home/domain/entities/home_item_kind.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  test('only overdue, open tasks are surfaced', () async {
    final repository = testRepository(db, now: testNow);
    await repository.create(NewTask(title: 'Overdue', dueDate: DateTime(2026, 9, 1)));
    final done = await repository.create(
      NewTask(title: 'Done but overdue', dueDate: DateTime(2026, 9, 1)),
    );
    await repository.setDone(done.id, done: true);
    await repository.create(NewTask(title: 'Not due yet', dueDate: DateTime(2026, 9, 20)));

    final source = TaskNeedsAttentionSource(repository);
    final items = await source.watch(today: testToday).first;

    expect(items, hasLength(1));
    expect(items.single.title, 'Overdue');
    expect(items.single.kind, HomeItemKind.task);
    expect(items.single.ctaLabel, 'View');
    expect(items.single.subtitle, contains('Overdue'));
  });

  test('reflects a task becoming overdue live', () async {
    final repository = testRepository(db, now: testNow);
    final task = await repository.create(
      NewTask(title: 'Renew passport', dueDate: testToday),
    );
    final source = TaskNeedsAttentionSource(repository);

    expect(await source.watch(today: testToday).first, isEmpty);

    final tomorrow = DateTime(testToday.year, testToday.month, testToday.day + 1);
    expect(
      (await source.watch(today: tomorrow).first).map((i) => i.id),
      [task.id],
    );
  });
}
