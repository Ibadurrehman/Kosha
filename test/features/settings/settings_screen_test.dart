import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/settings/presentation/settings_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/shared/widgets/kosha_toggle.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
  });

  tearDown(() => db.close());

  testWidgets('turning task reminders off cancels every scheduled one',
      (tester) async {
    final repository = testRepository(db, now: testNow, scheduler: scheduler);
    final task = await repository.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 10),
        reminderOffsetMinutes: 0,
      ),
    );
    scheduler.clear();

    await tester.pumpWidget(
      wrapScreen(const SettingsScreen(), db: db, now: testNow, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KoshaToggle).first);
    await tester.pumpAndSettle();

    expect(scheduler.cancelled, contains(task.id));
    await settleAndDispose(tester);
  });

  testWidgets('turning task reminders back on resyncs every eligible one',
      (tester) async {
    final repository = testRepository(db, now: testNow, scheduler: scheduler);
    final task = await repository.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 10),
        reminderOffsetMinutes: 0,
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const SettingsScreen(), db: db, now: testNow, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    // Off, then on again.
    await tester.tap(find.byType(KoshaToggle).first);
    await tester.pumpAndSettle();
    scheduler.clear();
    await tester.tap(find.byType(KoshaToggle).first);
    await tester.pumpAndSettle();

    expect(scheduler.scheduled.map((r) => r.ownerId), contains(task.id));
    await settleAndDispose(tester);
  });

  testWidgets('turning exact reminders on requests permission and resyncs',
      (tester) async {
    final repository = testRepository(db, now: testNow, scheduler: scheduler);
    final task = await repository.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 10),
        reminderOffsetMinutes: 0,
      ),
    );
    scheduler.clear();

    await tester.pumpWidget(
      wrapScreen(const SettingsScreen(), db: db, now: testNow, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KoshaToggle).at(1));
    await tester.pumpAndSettle();

    expect(scheduler.exactAlarmsEnabled, isTrue);
    expect(scheduler.scheduled.map((r) => r.ownerId), contains(task.id));
    await settleAndDispose(tester);
  });

  testWidgets('declining the exact-alarm permission leaves the setting off',
      (tester) async {
    scheduler.grantExactAlarmsPermission = false;

    await tester.pumpWidget(
      wrapScreen(const SettingsScreen(), db: db, now: testNow, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KoshaToggle).at(1));
    await tester.pumpAndSettle();

    expect(scheduler.exactAlarmsEnabled, isFalse);
    expect(
      tester.widget<KoshaToggle>(find.byType(KoshaToggle).at(1)).value,
      isFalse,
    );
    await settleAndDispose(tester);
  });

  testWidgets('static rows name the phase they arrive in', (tester) async {
    await tester.pumpWidget(wrapScreen(const SettingsScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phase 4'), findsWidgets);
    await settleAndDispose(tester);
  });
}
