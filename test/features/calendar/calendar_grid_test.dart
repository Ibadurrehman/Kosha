import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/calendar/domain/calendar_grid.dart';

void main() {
  group('monthGridDays', () {
    test('always returns 42 days starting on a Monday', () {
      final days = monthGridDays(DateTime(2026, 9, 4));
      expect(days, hasLength(42));
      expect(days.first.weekday, DateTime.monday);
    });

    test('spills into the neighbouring months to fill the grid', () {
      // September 2026 starts on a Tuesday, so the grid's first row leads
      // with the last Monday of August.
      final days = monthGridDays(DateTime(2026, 9, 15));
      expect(days.first, DateTime(2026, 8, 31));
      expect(days.contains(DateTime(2026, 9, 1)), isTrue);
      expect(days.contains(DateTime(2026, 9, 30)), isTrue);
    });

    test('handles a year boundary', () {
      final days = monthGridDays(DateTime(2026, 12, 25));
      expect(days.any((d) => d.year == 2027), isTrue);
    });
  });

  group('weekDays', () {
    test('returns 7 days starting on Monday', () {
      final days = weekDays(DateTime(2026, 9, 4)); // a Friday
      expect(days, hasLength(7));
      expect(days.first, DateTime(2026, 8, 31));
      expect(days.last, DateTime(2026, 9, 6));
    });

    test('a Monday is its own week start', () {
      final days = weekDays(DateTime(2026, 9, 7));
      expect(days.first, DateTime(2026, 9, 7));
    });
  });

  group('isSameDay', () {
    test('ignores time of day', () {
      expect(
        isSameDay(DateTime(2026, 9, 4, 8), DateTime(2026, 9, 4, 23, 59)),
        isTrue,
      );
      expect(isSameDay(DateTime(2026, 9, 4), DateTime(2026, 9, 5)), isFalse);
    });
  });
}
