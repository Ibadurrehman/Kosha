import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/calendar/data/event_repository_impl.dart';
import 'package:kosha/features/notifications/data/notification_repository_impl.dart';
import 'package:kosha/features/notifications/presentation/notifications_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('an empty inbox explains itself', (tester) async {
    await tester.pumpWidget(wrapScreen(const NotificationsScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Nothing yet'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a reconciled reminder shows under Today with its title',
      (tester) async {
    final tasks = testRepository(db, now: testNow);
    await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );
    final events = DriftEventRepository(
      db,
      FixedClock(testNow),
      const NoopReminderScheduler(),
    );
    await DriftNotificationRepository(db, FixedClock(testNow), tasks, events)
        .reconcile(now: testNow);

    await tester.pumpWidget(wrapScreen(const NotificationsScreen(), db: db));
    await tester.pumpAndSettle();

    // SectionLabel upper-cases its text.
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('Renew passport'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
