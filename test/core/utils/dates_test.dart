import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/utils/dates.dart';

void main() {
  group('dateOnly', () {
    test('strips the time', () {
      expect(dateOnly(DateTime(2026, 9, 4, 23, 59, 59)), DateTime(2026, 9, 4));
    });

    test('leaves a midnight alone', () {
      expect(dateOnly(DateTime(2026, 9, 4)), DateTime(2026, 9, 4));
    });
  });

  group('addDays', () {
    test('steps within a month', () {
      expect(addDays(DateTime(2026, 9, 4), 3), DateTime(2026, 9, 7));
    });

    test('rolls over a month boundary', () {
      expect(addDays(DateTime(2026, 9, 30), 1), DateTime(2026, 10));
      expect(addDays(DateTime(2026, 1, 31), 1), DateTime(2026, 2));
    });

    test('rolls over a year boundary', () {
      expect(addDays(DateTime(2026, 12, 31), 1), DateTime(2027));
    });

    test('handles a leap day and the year that has none', () {
      expect(addDays(DateTime(2028, 2, 28), 1), DateTime(2028, 2, 29));
      expect(addDays(DateTime(2026, 2, 28), 1), DateTime(2026, 3));
    });

    test('goes backwards with a negative count', () {
      expect(addDays(DateTime(2026), -1), DateTime(2025, 12, 31));
      expect(addDays(DateTime(2026, 3), -1), DateTime(2026, 2, 28));
    });

    test('keeps the time of day', () {
      expect(
        addDays(DateTime(2026, 9, 4, 18, 30), 1),
        DateTime(2026, 9, 5, 18, 30),
      );
    });

    test('stepping day by day always lands on midnight', () {
      // The property that `add(Duration(days: 1))` loses across a daylight
      // saving transition: 24 hours after a local midnight is not necessarily
      // the next local midnight. Building from calendar parts is what keeps
      // the calendar grid's cells usable as map keys (they are compared for
      // exact equality against items' own local-midnight dates).
      var day = DateTime(2026);
      for (var i = 0; i < 400; i++) {
        expect(day.hour, 0, reason: 'day $i drifted off midnight');
        expect(day, dateOnly(day));
        day = addDays(day, 1);
      }
    });
  });

  group('addWeeks', () {
    test('is seven days at a time', () {
      expect(addWeeks(DateTime(2026, 9, 4), 1), DateTime(2026, 9, 11));
      expect(addWeeks(DateTime(2026, 9, 4), -1), DateTime(2026, 8, 28));
    });

    test('keeps the weekday it started on', () {
      final start = DateTime(2026, 9, 4);
      for (var i = -20; i <= 20; i++) {
        expect(addWeeks(start, i).weekday, start.weekday);
      }
    });
  });
}
