import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/services/recurrence/recurrence.dart';

void main() {
  group('ruleFor', () {
    test('never has no rule', () {
      expect(Recurrence.ruleFor(RecurrencePreset.never), isNull);
    });

    test('daily, weekly and yearly are plain frequencies', () {
      expect(Recurrence.ruleFor(RecurrencePreset.daily), 'FREQ=DAILY');
      expect(Recurrence.ruleFor(RecurrencePreset.weekly), 'FREQ=WEEKLY');
      expect(Recurrence.ruleFor(RecurrencePreset.yearly), 'FREQ=YEARLY');
    });

    test('monthly anchors on the start day so the series cannot drift', () {
      expect(
        Recurrence.ruleFor(
          RecurrencePreset.monthly,
          start: DateTime(2026, 9, 10),
        ),
        'FREQ=MONTHLY;BYMONTHDAY=10',
      );
    });

    test('a start on the last day anchors to the last day', () {
      expect(
        Recurrence.ruleFor(
          RecurrencePreset.monthly,
          start: DateTime(2026, 9, 30),
        ),
        'FREQ=MONTHLY;BYMONTHDAY=-1',
      );
    });

    test('quarterly is monthly every third month', () {
      expect(
        Recurrence.ruleFor(
          RecurrencePreset.quarterly,
          start: DateTime(2026, 9, 12),
        ),
        'FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=12',
      );
    });
  });

  group('presetOf', () {
    test('round-trips every preset', () {
      final start = DateTime(2026, 9, 12);
      for (final preset in RecurrencePreset.values) {
        final rule = Recurrence.ruleFor(preset, start: start);
        expect(Recurrence.presetOf(rule), preset, reason: preset.name);
      }
    });

    test('an absent or unreadable rule is never', () {
      expect(Recurrence.presetOf(null), RecurrencePreset.never);
      expect(Recurrence.presetOf(''), RecurrencePreset.never);
      expect(Recurrence.presetOf('nonsense'), RecurrencePreset.never);
    });

    test('tolerates the RRULE prefix and lower case', () {
      expect(
        Recurrence.presetOf('RRULE:freq=daily'),
        RecurrencePreset.daily,
      );
    });
  });

  group('nextAfter', () {
    test('daily and weekly step by whole days', () {
      expect(
        Recurrence.nextAfter('FREQ=DAILY', DateTime(2026, 9, 4)),
        DateTime(2026, 9, 5),
      );
      expect(
        Recurrence.nextAfter('FREQ=WEEKLY', DateTime(2026, 9, 4)),
        DateTime(2026, 9, 11),
      );
    });

    test('crosses month and year boundaries', () {
      expect(
        Recurrence.nextAfter('FREQ=DAILY', DateTime(2026, 12, 31)),
        DateTime(2027, 1, 1),
      );
    });

    test('monthly clamps into a short month without drifting afterwards', () {
      const rule = 'FREQ=MONTHLY;BYMONTHDAY=30';
      final february = Recurrence.nextAfter(rule, DateTime(2027, 1, 30));
      expect(february, DateTime(2027, 2, 28));
      expect(
        Recurrence.nextAfter(rule, february!),
        DateTime(2027, 3, 30),
      );
    });

    test('a last-day rule stays on the last day', () {
      const rule = 'FREQ=MONTHLY;BYMONTHDAY=-1';
      expect(
        Recurrence.nextAfter(rule, DateTime(2027, 1, 31)),
        DateTime(2027, 2, 28),
      );
      expect(
        Recurrence.nextAfter(rule, DateTime(2028, 1, 31)),
        DateTime(2028, 2, 29),
      );
    });

    test('quarterly steps three months', () {
      expect(
        Recurrence.nextAfter(
          'FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=12',
          DateTime(2026, 9, 12),
        ),
        DateTime(2026, 12, 12),
      );
    });

    test('yearly steps twelve months and clamps 29 February', () {
      expect(
        Recurrence.nextAfter('FREQ=YEARLY', DateTime(2026, 9, 4)),
        DateTime(2027, 9, 4),
      );
      expect(
        Recurrence.nextAfter('FREQ=YEARLY', DateTime(2028, 2, 29)),
        DateTime(2029, 2, 28),
      );
    });

    test('ignores the time of day on the date it is given', () {
      expect(
        Recurrence.nextAfter('FREQ=DAILY', DateTime(2026, 9, 4, 23, 30)),
        DateTime(2026, 9, 5),
      );
    });

    test('returns null for rules it cannot read', () {
      expect(Recurrence.nextAfter(null, DateTime(2026, 9, 4)), isNull);
      expect(Recurrence.nextAfter('FREQ=HOURLY', DateTime(2026, 9, 4)), isNull);
      expect(
        Recurrence.nextAfter('FREQ=DAILY;INTERVAL=0', DateTime(2026, 9, 4)),
        isNull,
      );
    });
  });

  group('label', () {
    test('names the preset behind a rule', () {
      expect(Recurrence.label('FREQ=DAILY'), 'Daily');
      expect(Recurrence.label('FREQ=MONTHLY;INTERVAL=3'), 'Quarterly');
      expect(Recurrence.label(null), 'Never');
    });
  });
}
