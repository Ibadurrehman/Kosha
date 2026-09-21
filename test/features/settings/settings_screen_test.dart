import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/settings/presentation/settings_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/shared/widgets/kosha_toggle.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;

  /// Toggles are found by the label they announce, not by position — the
  /// Notifications group gains rows as features land, and an index would
  /// silently start driving a different switch.
  Finder toggle(String label) => find.byWidgetPredicate(
        (widget) => widget is KoshaToggle && widget.semanticLabel == label,
      );

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

    await tester.tap(toggle('Task reminders'));
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
    await tester.tap(toggle('Task reminders'));
    await tester.pumpAndSettle();
    scheduler.clear();
    await tester.tap(toggle('Task reminders'));
    await tester.pumpAndSettle();

    expect(scheduler.scheduled.map((r) => r.ownerId), contains(task.id));
    await settleAndDispose(tester);
  });

  testWidgets('turning bill reminders off cancels every scheduled bill',
      (tester) async {
    final bills = testBillRepository(db, now: testNow, scheduler: scheduler);
    final bill = await bills.create(
      NewBill(
        name: 'Electricity',
        amountMinor: 185000,
        nextDue: DateTime(2026, 9, 10),
      ),
    );
    scheduler.clear();

    await tester.pumpWidget(
      wrapScreen(const SettingsScreen(), db: db, now: testNow, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    await tester.tap(toggle('Bill reminders'));
    await tester.pumpAndSettle();
    expect(scheduler.cancelled, contains(bill.id));

    scheduler.clear();
    await tester.tap(toggle('Bill reminders'));
    await tester.pumpAndSettle();
    expect(scheduler.scheduled.map((r) => r.ownerId), contains(bill.id));
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

    await tester.tap(toggle('Exact reminders'));
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

    await tester.tap(toggle('Exact reminders'));
    await tester.pumpAndSettle();

    expect(scheduler.exactAlarmsEnabled, isFalse);
    expect(
      tester.widget<KoshaToggle>(toggle('Exact reminders')).value,
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
