import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/task_detail_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

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
          description: 'Consumer 4402 1187 · pay by UPI.',
          dueDate: testToday,
          dueMinutes: 9 * 60,
          priority: Priority.high,
          category: 'Home',
          recurrenceRule: 'FREQ=MONTHLY;BYMONTHDAY=4',
          reminderOffsetMinutes: 24 * 60,
        ),
      );

  /// The detail screen is longer than the default 600 px test viewport, and a
  /// lazy list does not build what is below the fold. A tall phone-shaped
  /// window keeps the whole screen in the tree so the tests can find it.
  Future<void> open(WidgetTester tester, Task task) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapScreen(TaskDetailScreen(taskId: task.id), db: db),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the badge, title, description and all seven fields',
      (tester) async {
    await open(tester, await seed());

    expect(find.text('Due today'), findsOneWidget);
    expect(find.text('Pay electricity bill'), findsOneWidget);
    expect(find.text('Consumer 4402 1187 · pay by UPI.'), findsOneWidget);

    for (final label in [
      'Due date',
      'Time',
      'Priority',
      'Repeat',
      'Reminder',
      'Category',
      'Status',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }

    expect(find.text('4 Sep 2026'), findsOneWidget);
    expect(find.text('9:00 AM'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('1 day before'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the expander reveals notes and the activity history',
      (tester) async {
    await open(tester, await seed());

    expect(find.text('ACTIVITY'), findsNothing);

    await tester.tap(find.text('Notes and activity'));
    await tester.pumpAndSettle();

    expect(find.text('NOTES'), findsOneWidget);
    expect(find.text('ACTIVITY'), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);

    await tester.tap(find.text('Hide details'));
    await tester.pumpAndSettle();
    expect(find.text('ACTIVITY'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('Complete finishes the task and offers an undo', (tester) async {
    await open(tester, await seed());

    await tester.tap(find.widgetWithText(FilledButton, 'Complete'));
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Reopen'), findsOneWidget);
    // The task repeats monthly, so the toast names the next occurrence.
    expect(find.textContaining('next on 4 Oct'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Complete'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('Delete asks first and can be dismissed', (tester) async {
    final task = await seed();
    await open(tester, task);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete this task?'), findsOneWidget);
    expect(find.textContaining('repeats'), findsOneWidget);

    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();

    expect(await repository.findById(task.id), isNotNull);
    await settleAndDispose(tester);
  });

  testWidgets('a deleted task shows an explanation instead of blank fields',
      (tester) async {
    final task = await seed();
    await open(tester, task);

    await repository.softDelete(task.id);
    await tester.pumpAndSettle();

    expect(find.text('This task is gone'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the actions sheet lists every action', (tester) async {
    await open(tester, await seed());

    await tester.tap(find.byIcon(Symbols.more_horiz_rounded).first);
    await tester.pumpAndSettle();

    for (final label in [
      'Complete',
      'Reschedule',
      'Duplicate',
      'Delete',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    // The sheet does not offer to open the screen it was opened from.
    expect(find.text('Open details'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('the reschedule sheet names the date the task is on now',
      (tester) async {
    await open(tester, await seed());

    await tester.tap(find.byIcon(Symbols.more_horiz_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reschedule'));
    await tester.pumpAndSettle();

    expect(find.text('Currently 4 Sep'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Pick a date'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
