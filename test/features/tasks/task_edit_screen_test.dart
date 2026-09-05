import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/core/services/recurrence/recurrence.dart';
import 'package:kosha/core/utils/formatters.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/task_edit_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRepository(db);
  });

  tearDown(() => db.close());

  Future<Task> seed() => repository.create(
        NewTask(
          title: 'Pay electricity bill',
          description: 'Consumer 4402 1187.',
          dueDate: testToday,
          dueMinutes: 9 * 60,
          priority: Priority.high,
          category: 'Home',
        ),
      );

  /// The editor is taller than the default 600 px test viewport and its list is
  /// lazy, so the window is made phone-shaped to keep every field in the tree.
  Future<void> open(WidgetTester tester, Task task) async {
    tester.view.physicalSize = const Size(400, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapPushedScreen(TaskEditScreen(taskId: task.id), db: db),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens with the task already filled in', (tester) async {
    await open(tester, await seed());

    expect(find.widgetWithText(TextField, 'Pay electricity bill'),
        findsOneWidget);
    expect(find.widgetWithText(TextField, 'Consumer 4402 1187.'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Home'), findsOneWidget);
    expect(find.text(Dates.dayMonthYear(testToday)), findsOneWidget);
    expect(find.text(Dates.minuteOfDay(9 * 60)), findsOneWidget);

    await settleAndDispose(tester);
  });

  testWidgets('saving writes the edits and returns to the screen behind',
      (tester) async {
    final task = await seed();
    await open(tester, task);

    await tester.enterText(
      find.widgetWithText(TextField, 'Pay electricity bill'),
      'Pay the electricity bill',
    );
    await tester.tap(find.text('Medium'));
    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final saved = await repository.findById(task.id);
    expect(saved!.title, 'Pay the electricity bill');
    expect(saved.priority, Priority.medium);
    expect(Recurrence.presetOf(saved.recurrenceRule), RecurrencePreset.monthly);
    expect(saved.createdAt, testNow, reason: 'creation time is not rewritten');

    expect(find.text('Saved “Pay the electricity bill”'), findsOneWidget);
    expect(find.text('behind'), findsOneWidget);

    await settleAndDispose(tester);
  });

  testWidgets('Save is disabled while the title is empty', (tester) async {
    await open(tester, await seed());

    await tester.enterText(
      find.widgetWithText(TextField, 'Pay electricity bill'),
      '   ',
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save changes'),
    );
    expect(button.onPressed, isNull);

    await settleAndDispose(tester);
  });

  testWidgets('clearing the due date drops the time with it', (tester) async {
    final task = await seed();
    await open(tester, task);

    await tester.tap(find.byTooltip('Clear Due date'));
    await tester.pumpAndSettle();
    expect(find.text('Not set'), findsOneWidget);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final saved = await repository.findById(task.id);
    expect(saved!.dueDate, isNull);
    expect(saved.dueMinutes, isNull, reason: 'a time needs a date to fire on');

    await settleAndDispose(tester);
  });

  testWidgets('a task deleted while it was open explains itself',
      (tester) async {
    final task = await seed();
    await open(tester, task);

    await repository.softDelete(task.id);
    await tester.pumpAndSettle();

    expect(find.text('This task is gone'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
