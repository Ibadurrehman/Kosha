import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/features/calendar/domain/entities/event.dart';
import 'package:kosha/features/calendar/domain/event_reminder.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);

  Event event({
    required DateTime startAt,
    int? reminder,
    bool allDay = false,
  }) =>
      Event(
        id: 'event-1',
        title: 'Doctor',
        startAt: startAt,
        allDay: allDay,
        reminderOffsetMinutes: reminder,
        createdAt: now,
        updatedAt: now,
      );

  group('reminderForEvent', () {
    test('fires the lead time before the start time', () {
      final reminder = reminderForEvent(
        event(startAt: DateTime(2026, 9, 10, 10), reminder: 60),
        now: now,
      );
      expect(reminder!.fireAt, DateTime(2026, 9, 10, 9));
      expect(reminder.kind, ReminderKind.event);
      expect(reminder.ownerId, 'event-1');
      expect(reminder.route, '/calendar');
    });

    test('no reminder without a lead time', () {
      expect(
        reminderForEvent(event(startAt: DateTime(2026, 9, 10, 10)), now: now),
        isNull,
      );
    });

    test('a moment already past is not scheduled', () {
      expect(
        reminderForEvent(
          event(startAt: DateTime(2026, 9, 4, 9), reminder: 0),
          now: now,
        ),
        isNull,
      );
    });

    test('the body names the lead time', () {
      final reminder = reminderForEvent(
        event(startAt: DateTime(2026, 9, 10, 10), reminder: 24 * 60),
        now: now,
      );
      expect(reminder!.body, 'Starts in a day');
    });

    test('an all-day event says so instead of a lead time', () {
      final reminder = reminderForEvent(
        event(startAt: DateTime(2026, 9, 10), reminder: 0, allDay: true),
        now: now,
      );
      expect(reminder!.body, 'All day');
    });
  });

  group('intendedEventFireAt', () {
    test('is the start time minus the offset, even in the past', () {
      expect(
        intendedEventFireAt(
          event(startAt: DateTime(2026, 9, 1, 10), reminder: 60),
        ),
        DateTime(2026, 9, 1, 9),
      );
    });

    test('is null without an offset', () {
      expect(intendedEventFireAt(event(startAt: DateTime(2026, 9, 10))), isNull);
    });
  });
}
