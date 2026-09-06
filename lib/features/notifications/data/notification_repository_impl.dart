import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/clock.dart';
import '../../bills/data/bill_repository_impl.dart';
import '../../bills/domain/bill_reminder.dart';
import '../../bills/domain/bill_repository.dart';
import '../../calendar/data/event_repository_impl.dart';
import '../../calendar/domain/entities/event.dart';
import '../../calendar/domain/event_reminder.dart';
import '../../calendar/domain/event_repository.dart';
import '../../tasks/data/task_repository_impl.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/domain/task_reminder.dart';
import '../../tasks/domain/task_repository.dart';
import '../domain/entities/notification_entry.dart';
import '../domain/notification_repository.dart';

part 'notification_repository_impl.g.dart';

/// SQLite-backed notification inbox. `reconcile()` never talks to
/// `task_table.dart`/`event_table.dart` directly — only through the
/// repository interfaces, the same cross-feature-read rule Home's
/// aggregators follow (section 4.2).
class DriftNotificationRepository implements NotificationRepository {
  DriftNotificationRepository(
    this._db,
    this._clock,
    this._tasks,
    this._events,
    this._bills,
  );

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final TaskRepository _tasks;
  final EventRepository _events;
  final BillRepository _bills;

  @override
  Stream<List<NotificationEntry>> watchInbox() {
    final query = _db.select(_db.notifications)
      ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<int> watchUnreadCount() {
    final query = _db.select(_db.notifications)..where((n) => n.readAt.isNull());
    return query.watch().map((rows) => rows.length);
  }

  @override
  Future<void> markRead(String id) async {
    await (_db.update(_db.notifications)..where((n) => n.id.equals(id)))
        .write(NotificationsCompanion(readAt: Value(_clock.now())));
  }

  @override
  Future<void> markAllRead() async {
    await (_db.update(_db.notifications)..where((n) => n.readAt.isNull()))
        .write(NotificationsCompanion(readAt: Value(_clock.now())));
  }

  @override
  Future<void> markReadForOwner(ReminderKind kind, String ownerId) async {
    await (_db.update(_db.notifications)
          ..where(
            (n) =>
                n.kind.equalsValue(kind) &
                n.ownerId.equals(ownerId) &
                n.readAt.isNull(),
          ))
        .write(NotificationsCompanion(readAt: Value(_clock.now())));
  }

  @override
  Future<void> reconcile({required DateTime now}) async {
    for (final task in await _tasks.remindable()) {
      await _reconcileOne(
        kind: ReminderKind.task,
        ownerId: task.id,
        title: task.title,
        body: _dueTaskBody(task),
        route: '/tasks/${task.id}',
        fireAt: intendedFireAt(task),
        now: now,
      );
    }
    for (final event in await _events.remindable()) {
      await _reconcileOne(
        kind: ReminderKind.event,
        ownerId: event.id,
        title: event.title,
        body: _dueEventBody(event),
        route: '/calendar',
        fireAt: intendedEventFireAt(event),
        now: now,
      );
    }
    for (final bill in await _bills.remindable()) {
      await _reconcileOne(
        kind: ReminderKind.bill,
        ownerId: bill.id,
        title: bill.name,
        body: billReminderBody(bill),
        route: '/home/finance/bills/${bill.id}',
        fireAt: intendedBillFireAt(bill),
        now: now,
      );
    }
  }

  String? _dueTaskBody(Task task) {
    final offset = task.reminderOffsetMinutes;
    return offset == null ? null : taskReminderBody(task, offset);
  }

  String? _dueEventBody(Event event) {
    final offset = event.reminderOffsetMinutes;
    return offset == null ? null : eventReminderBody(event, offset);
  }

  Future<void> _reconcileOne({
    required ReminderKind kind,
    required String ownerId,
    required String title,
    required String? body,
    required String route,
    required DateTime? fireAt,
    required DateTime now,
  }) async {
    if (fireAt == null || fireAt.isAfter(now)) return;
    final dedupeKey = '${kind.name}:$ownerId:${fireAt.toIso8601String()}';
    await _db.into(_db.notifications).insert(
          NotificationsCompanion.insert(
            id: _uuid.v4(),
            kind: kind,
            ownerId: ownerId,
            title: title,
            body: Value(body),
            route: Value(route),
            dedupeKey: dedupeKey,
            createdAt: fireAt,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  NotificationEntry _toDomain(NotificationRow row) => NotificationEntry(
        id: row.id,
        kind: row.kind,
        ownerId: row.ownerId,
        title: row.title,
        body: row.body,
        route: row.route,
        createdAt: row.createdAt,
        readAt: row.readAt,
      );
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) => DriftNotificationRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(taskRepositoryProvider),
      ref.watch(eventRepositoryProvider),
      ref.watch(billRepositoryProvider),
    );
