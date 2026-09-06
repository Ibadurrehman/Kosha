import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/calendar/data/event_repository_impl.dart';
import 'package:kosha/features/calendar/domain/entities/event.dart';
import 'package:kosha/features/calendar/domain/event_repository.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);

  late AppDatabase db;
  late EventRepository repository;
  late RecordingReminderScheduler scheduler;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    repository = DriftEventRepository(db, FixedClock(now), scheduler);
  });

  tearDown(() => db.close());

  group('create', () {
    test('assigns an id and timestamps from the clock', () async {
      final event = await repository.create(
        NewEvent(title: 'Doctor', startAt: DateTime(2026, 9, 10, 10)),
      );
      expect(event.id, isNotEmpty);
      expect(event.createdAt, now);
      expect(event.updatedAt, now);
      expect(await repository.findById(event.id), event);
    });

    test('trims the title', () async {
      final event = await repository.create(
        NewEvent(title: '  Gym  ', startAt: DateTime(2026, 9, 10, 18)),
      );
      expect(event.title, 'Gym');
    });

    test('schedules a reminder when a lead time is set', () async {
      final event = await repository.create(
        NewEvent(
          title: 'Doctor',
          startAt: DateTime(2026, 9, 10, 10),
          reminderOffsetMinutes: 60,
        ),
      );
      final scheduled = scheduler.latestFor(event.id);
      expect(scheduled, isNotNull);
      expect(scheduled!.kind, ReminderKind.event);
      expect(scheduled.fireAt, DateTime(2026, 9, 10, 9));
    });

    test('schedules no reminder when the offset is null', () async {
      final event = await repository.create(
        NewEvent(title: 'Gym', startAt: DateTime(2026, 9, 10, 18)),
      );
      expect(scheduler.latestFor(event.id), isNull);
    });
  });

  group('watchInRange', () {
    test('only returns events starting in the half-open window', () async {
      final before = await repository.create(
        NewEvent(title: 'Before', startAt: DateTime(2026, 9, 1)),
      );
      final inside = await repository.create(
        NewEvent(title: 'Inside', startAt: DateTime(2026, 9, 10)),
      );
      final after = await repository.create(
        NewEvent(title: 'After', startAt: DateTime(2026, 9, 20)),
      );

      final results = await repository
          .watchInRange(DateTime(2026, 9, 5), DateTime(2026, 9, 15))
          .first;

      expect(results.map((e) => e.id), [inside.id]);
      expect(before.title, 'Before');
      expect(after.title, 'After');
    });
  });

  group('save', () {
    test('keeps the original createdAt and bumps updatedAt', () async {
      final event = await repository.create(
        NewEvent(title: 'Gym', startAt: DateTime(2026, 9, 10, 18)),
      );
      final later = FixedClock(now.add(const Duration(days: 1)));
      final laterRepository = DriftEventRepository(db, later, scheduler);
      final updated = await laterRepository.save(
        event.copyWith(startAt: DateTime(2026, 9, 11, 18)),
      );
      expect(updated.createdAt, now);
      expect(updated.updatedAt, later.now());
      expect(updated.startAt, DateTime(2026, 9, 11, 18));
    });
  });

  group('soft delete / restore / purge', () {
    test('soft delete hides the event and cancels its reminder', () async {
      final event = await repository.create(
        NewEvent(
          title: 'Doctor',
          startAt: DateTime(2026, 9, 10, 10),
          reminderOffsetMinutes: 60,
        ),
      );
      await repository.softDelete(event.id);

      expect(await repository.findById(event.id), isNull);
      expect(scheduler.cancelled, contains(event.id));
    });

    test('restore brings a soft-deleted event back and re-syncs its reminder',
        () async {
      final event = await repository.create(
        NewEvent(
          title: 'Doctor',
          startAt: DateTime(2026, 9, 10, 10),
          reminderOffsetMinutes: 60,
        ),
      );
      await repository.softDelete(event.id);
      scheduler.clear();
      await repository.restore(event.id);

      expect(await repository.findById(event.id), isNotNull);
      expect(scheduler.latestFor(event.id), isNotNull);
    });

    test('purge removes the row entirely', () async {
      final event = await repository.create(
        NewEvent(title: 'Gym', startAt: DateTime(2026, 9, 10, 18)),
      );
      await repository.purge(event.id);
      expect(await db.select(db.events).get(), isEmpty);
    });
  });

  group('resyncReminders', () {
    test('re-states only events that still want a reminder', () async {
      final wanted = await repository.create(
        NewEvent(
          title: 'Doctor',
          startAt: DateTime(2026, 9, 10, 10),
          reminderOffsetMinutes: 60,
        ),
      );
      final unreminded = await repository.create(
        NewEvent(title: 'Gym', startAt: DateTime(2026, 9, 11, 18)),
      );
      scheduler.clear();

      await repository.resyncReminders();

      expect(scheduler.scheduled.map((r) => r.ownerId), [wanted.id]);
      expect(scheduler.cancelled, isNot(contains(unreminded.id)));
    });
  });
}
