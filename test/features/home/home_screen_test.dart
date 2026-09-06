import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/home/presentation/home_screen.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/widgets/task_row.dart'
    as widgets;

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRepository(db);
  });

  tearDown(() => db.close());

  testWidgets('greets by time of day and dates the day in full',
      (tester) async {
    await tester.pumpWidget(wrapScreen(const HomeScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Friday, 4 September 2026'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('greets in the evening after five', (tester) async {
    await tester.pumpWidget(
      wrapScreen(const HomeScreen(), db: db, now: DateTime(2026, 9, 4, 20, 10)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good evening'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('shows the empty state when nothing is due today',
      (tester) async {
    await repository.create(
      NewTask(title: 'Review documents', dueDate: DateTime(2026, 9, 12)),
    );
    await tester.pumpWidget(wrapScreen(const HomeScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Nothing planned for today'), findsOneWidget);
    // The task still shows up in Recent — Today specifically has no rows.
    expect(find.byType(widgets.TaskRow), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('counts what is left and keeps completed tasks in view',
      (tester) async {
    await repository.create(
      NewTask(title: 'Buy groceries', dueDate: testToday, dueMinutes: 18 * 60),
    );
    final exercise = await repository.create(
      NewTask(title: 'Exercise', dueDate: testToday, dueMinutes: 7 * 60),
    );
    await repository.setDone(exercise.id, done: true);

    await tester.pumpWidget(wrapScreen(const HomeScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('1 of 2 left'), findsOneWidget);
    // Scoped to Today's rows specifically — Recent also shows both titles.
    expect(
      find.descendant(of: find.byType(widgets.TaskRow), matching: find.text('Buy groceries')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byType(widgets.TaskRow), matching: find.text('Exercise')),
      findsOneWidget,
    );
    expect(find.text('Add a task'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
