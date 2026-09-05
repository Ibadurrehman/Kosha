import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/clock.dart';
import '../domain/entities/event.dart';
import '../domain/event_reminder.dart';
import '../domain/event_repository.dart';

part 'event_repository_impl.g.dart';

/// SQLite-backed events. Mirrors `DriftTaskRepository`'s shape: every write
/// re-syncs the reminder the operating system holds for the row.
class DriftEventRepository implements EventRepository {
  DriftEventRepository(this._db, this._clock, this._scheduler);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;

  @override
  Stream<List<Event>> watchInRange(DateTime from, DateTime to) {
    final query = _db.select(_db.events)
      ..where(
        (e) =>
            e.deletedAt.isNull() &
            e.startAt.isBiggerOrEqualValue(from) &
            e.startAt.isSmallerThanValue(to),
      )
      ..orderBy([(e) => OrderingTerm.asc(e.startAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<Event?> watchById(String id) {
    final query = _db.select(_db.events)
      ..where((e) => e.id.equals(id) & e.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Future<Event?> findById(String id) async {
    final row = await (_db.select(_db.events)
          ..where((e) => e.id.equals(id) & e.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Event> create(NewEvent draft) async {
    final now = _clock.now();
    final event = Event(
      id: _uuid.v4(),
      title: draft.title.trim(),
      startAt: draft.startAt,
      endAt: draft.endAt,
      allDay: draft.allDay,
      description: draft.description,
      reminderOffsetMinutes: draft.reminderOffsetMinutes,
      spaceId: draft.spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.events).insert(_toRow(event));
    await _syncReminder(event);
    return event;
  }

  @override
  Future<Event> save(Event event) async {
    final existing = await _require(event.id);
    final updated = event.copyWith(
      createdAt: existing.createdAt,
      updatedAt: _clock.now(),
    );
    await _db.update(_db.events).replace(_toRow(updated));
    await _syncReminder(updated);
    return updated;
  }

  @override
  Future<void> softDelete(String id) async {
    await (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(deletedAt: Value(_clock.now()), updatedAt: Value(_clock.now())),
    );
    await _scheduler.cancel(ReminderKind.event, id);
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    final restored = await findById(id);
    if (restored != null) await _syncReminder(restored);
  }

  @override
  Future<void> purge(String id) async {
    await (_db.delete(_db.events)..where((e) => e.id.equals(id))).go();
    await _scheduler.cancel(ReminderKind.event, id);
  }

  @override
  Future<void> resyncReminders() async {
    for (final event in await remindable()) {
      await _syncReminder(event);
    }
  }

  @override
  Future<List<Event>> remindable() async {
    final rows = await (_db.select(_db.events)
          ..where(
            (e) => e.deletedAt.isNull() & e.reminderOffsetMinutes.isNotNull(),
          ))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<Event> _require(String id) async {
    final event = await findById(id);
    if (event == null) throw StateError('No event with id $id');
    return event;
  }

  Future<void> _syncReminder(Event event) async {
    final reminder = reminderForEvent(event, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.event, event.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  Event _toDomain(EventRow row) => Event(
        id: row.id,
        title: row.title,
        description: row.description,
        startAt: row.startAt,
        endAt: row.endAt,
        allDay: row.allDay,
        reminderOffsetMinutes: row.reminderOffsetMinutes,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  EventRow _toRow(Event event) => EventRow(
        id: event.id,
        title: event.title,
        description: event.description,
        startAt: event.startAt,
        endAt: event.endAt,
        allDay: event.allDay,
        reminderOffsetMinutes: event.reminderOffsetMinutes,
        spaceId: event.spaceId,
        createdAt: event.createdAt,
        updatedAt: event.updatedAt,
      );
}

@Riverpod(keepAlive: true)
EventRepository eventRepository(Ref ref) => DriftEventRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
    );
