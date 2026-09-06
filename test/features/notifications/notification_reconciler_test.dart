import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/bills/domain/bill_repository.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/calendar/data/event_repository_impl.dart';
import 'package:kosha/features/calendar/domain/entities/event.dart';
import 'package:kosha/features/calendar/domain/event_repository.dart';
import 'package:kosha/features/notifications/data/notification_repository_impl.dart';
import 'package:kosha/features/notifications/domain/notification_repository.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/domain/task_repository.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late TaskRepository tasks;
  late EventRepository events;
  late BillRepository bills;
  late NotificationRepository notifications;

  setUp(() {
    db = testDatabase();
    tasks = testRepository(db, now: testNow);
    events = DriftEventRepository(db, FixedClock(testNow), RecordingReminderScheduler());
    bills = testBillRepository(db, now: testNow);
    notifications = DriftNotificationRepository(
      db,
      FixedClock(testNow),
      tasks,
      events,
      bills,
    );
  });

  tearDown(() => db.close());

  test('a task whose reminder time has passed gets exactly one inbox row',
      () async {
    final task = await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );

    await notifications.reconcile(now: testNow);
    final inbox = await notifications.watchInbox().first;

    expect(inbox, hasLength(1));
    expect(inbox.single.ownerId, task.id);
    expect(inbox.single.kind, ReminderKind.task);
    expect(inbox.single.route, '/tasks/${task.id}');
  });

  test('a task whose reminder time has not passed yet is left alone',
      () async {
    await tasks.create(
      NewTask(
        title: 'Future task',
        dueDate: DateTime(2026, 9, 10),
        reminderOffsetMinutes: 0,
      ),
    );
    await notifications.reconcile(now: testNow);
    expect(await notifications.watchInbox().first, isEmpty);
  });

  test('reconciling twice never duplicates the same fired moment', () async {
    await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );

    await notifications.reconcile(now: testNow);
    await notifications.reconcile(now: testNow);
    await notifications.reconcile(now: testNow.add(const Duration(hours: 1)));

    expect(await notifications.watchInbox().first, hasLength(1));
  });

  test('rescheduling to a new past moment adds a second, distinct row',
      () async {
    final task = await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );
    await notifications.reconcile(now: testNow);
    expect(await notifications.watchInbox().first, hasLength(1));

    // Move it a day back, then reconcile again after that new moment passes.
    await tasks.reschedule(task.id, dueDate: DateTime(2026, 9, 3), dueMinutes: 8 * 60);
    await notifications.reconcile(now: testNow.add(const Duration(days: 1)));

    final inbox = await notifications.watchInbox().first;
    expect(inbox, hasLength(2));
    expect(inbox.every((n) => n.ownerId == task.id), isTrue);
  });

  test('an event whose reminder time has passed is reconciled too', () async {
    final event = await events.create(
      NewEvent(
        title: 'Doctor',
        startAt: DateTime(2026, 9, 4, 9),
        reminderOffsetMinutes: 30,
      ),
    );
    await notifications.reconcile(now: testNow);
    final inbox = await notifications.watchInbox().first;
    expect(inbox.single.ownerId, event.id);
    expect(inbox.single.kind, ReminderKind.event);
  });

  test('markRead and markAllRead update readAt and the unread count',
      () async {
    final task = await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );
    await notifications.reconcile(now: testNow);
    expect(await notifications.watchUnreadCount().first, 1);

    final id = (await notifications.watchInbox().first).single.id;
    await notifications.markRead(id);
    expect(await notifications.watchUnreadCount().first, 0);

    await tasks.reschedule(task.id, dueDate: DateTime(2026, 9, 3), dueMinutes: 8 * 60);
    await notifications.reconcile(now: testNow.add(const Duration(days: 1)));
    expect(await notifications.watchUnreadCount().first, 1);

    await notifications.markAllRead();
    expect(await notifications.watchUnreadCount().first, 0);
  });

  test('a bill whose lead time has passed gets an inbox row that says why',
      () async {
    final bill = await bills.create(
      NewBill(
        name: 'Society maintenance',
        amountMinor: 240000,
        // The 3-day lead fired on 30 August, before "now".
        nextDue: DateTime(2026, 9, 2),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );

    await notifications.reconcile(now: testNow);
    final inbox = await notifications.watchInbox().first;

    expect(inbox, hasLength(1));
    expect(inbox.single.kind, ReminderKind.bill);
    expect(inbox.single.ownerId, bill.id);
    expect(inbox.single.title, 'Society maintenance');
    expect(inbox.single.body, '₹2,400 · due in 3 days');
    expect(inbox.single.route, '/home/finance/bills/${bill.id}');
    // Dated at the moment it fired, not at reconciliation time.
    expect(inbox.single.createdAt, DateTime(2026, 8, 30, 9));
  });

  test('reconciling twice does not duplicate the bill row', () async {
    await bills.create(
      NewBill(
        name: 'Society maintenance',
        amountMinor: 240000,
        nextDue: DateTime(2026, 9, 2),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );

    await notifications.reconcile(now: testNow);
    await notifications.reconcile(now: testNow);

    expect(await notifications.watchInbox().first, hasLength(1));
  });

  test('a bill whose lead time is still ahead gets no row yet', () async {
    await bills.create(
      NewBill(
        name: 'Electricity',
        amountMinor: 185000,
        nextDue: DateTime(2026, 9, 20),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );

    await notifications.reconcile(now: testNow);
    expect(await notifications.watchInbox().first, isEmpty);
  });

  test('paying a bill stops it reconciling again, but keeps the row it earned',
      () async {
    final bill = await bills.create(
      NewBill(
        name: 'Society maintenance',
        amountMinor: 240000,
        nextDue: DateTime(2026, 9, 2),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );
    await notifications.reconcile(now: testNow);
    await bills.markPaid(bill.id);

    await notifications.reconcile(now: testNow);
    final inbox = await notifications.watchInbox().first;

    // The reminder did fire, so the history keeps it; the advanced cycle has
    // not fired yet, so nothing new is added.
    expect(inbox, hasLength(1));
  });

  test('markReadForOwner reads one bill’s rows and leaves the rest alone',
      () async {
    final bill = await bills.create(
      NewBill(
        name: 'Society maintenance',
        amountMinor: 240000,
        nextDue: DateTime(2026, 9, 2),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );
    await tasks.create(
      NewTask(
        title: 'Renew passport',
        dueDate: DateTime(2026, 9, 4),
        dueMinutes: 8 * 60,
        reminderOffsetMinutes: 0,
      ),
    );
    await notifications.reconcile(now: testNow);
    expect(await notifications.watchUnreadCount().first, 2);

    await notifications.markReadForOwner(ReminderKind.bill, bill.id);

    final inbox = await notifications.watchInbox().first;
    final billRow = inbox.firstWhere((e) => e.ownerId == bill.id);
    expect(billRow.isUnread, isFalse);
    // The row is still there: the reminder did fire, and the inbox records
    // what happened rather than what is outstanding.
    expect(inbox, hasLength(2));
    expect(await notifications.watchUnreadCount().first, 1);
  });
}
