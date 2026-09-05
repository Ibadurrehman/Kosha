import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/tasks_screen.dart';
import 'package:kosha/features/tasks/presentation/widgets/task_row.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRepository(db);
  });

  tearDown(() => db.close());

  testWidgets('opens on Today with the empty state', (tester) async {
    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Nothing planned for today'), findsOneWidget);
    expect(find.text('Add task'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('creates a task from the sheet, then undoes it', (tester) async {
    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    expect(find.text('New task'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Pay electricity bill');
    await tester.pump();
    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();

    expect(find.text('Pay electricity bill'), findsOneWidget);
    expect(find.textContaining('added to Today'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Pay electricity bill'), findsNothing);
    expect(await db.select(db.tasks).get(), isEmpty);
    await settleAndDispose(tester);
  });

  testWidgets('Create is disabled until the title has text', (tester) async {
    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    FilledButton create() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Create task'),
        );
    expect(create().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Call bank');
    await tester.pump();
    expect(create().onPressed, isNotNull);
    await settleAndDispose(tester);
  });

  testWidgets('the Today chip decides which tab the task lands in',
      (tester) async {
    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'File ITR acknowledgement');
    await tester.pump();
    // Turn "Today" off, so the task has no date and goes to the inbox.
    await tester.tap(find.text('Today').last);
    await tester.pump();
    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();

    expect(find.textContaining('added to Inbox'), findsOneWidget);
    expect(find.text('File ITR acknowledgement'), findsNothing);

    await tester.tap(find.text('Inbox'));
    await tester.pumpAndSettle();
    expect(find.text('File ITR acknowledgement'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('completing a task clears Today and undo restores it',
      (tester) async {
    await repository.create(
      NewTask(
        title: 'Buy groceries',
        dueDate: testToday,
        dueMinutes: 18 * 60,
      ),
    );
    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('6:00 PM'), findsOneWidget);

    await tester.tap(find.byKey(taskCheckboxKey));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsNothing);
    expect(find.text('Completed “Buy groceries”'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the Completed tab lists finished tasks', (tester) async {
    final task = await repository.create(
      NewTask(title: 'Exercise', dueDate: testToday, dueMinutes: 7 * 60),
    );
    await repository.setDone(task.id, done: true);

    await tester.pumpWidget(wrapScreen(const TasksScreen(), db: db));
    await tester.pumpAndSettle();
    expect(find.text('Exercise'), findsNothing);

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Exercise'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
