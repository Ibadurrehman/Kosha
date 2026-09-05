import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/core/utils/formatters.dart';

void main() {
  group('Money.inr', () {
    test('uses Indian digit grouping and whole rupees', () {
      expect(Money.inr(20000000), '₹2,00,000');
      expect(Money.inr(185000), '₹1,850');
      expect(Money.inr(64900), '₹649');
    });

    test('rounds paise and ignores sign like the prototype', () {
      expect(Money.inr(185050), '₹1,851');
      expect(Money.inr(-395000), '₹3,950');
    });

    test('inrExact keeps paise', () {
      expect(Money.inrExact(185050), '₹1,850.50');
    });
  });

  group('Dates', () {
    final d = DateTime(2026, 9, 4, 9);

    test('formats in the profile default styles', () {
      expect(Dates.dayMonth(d), '4 Sep');
      expect(Dates.dayMonthYear(d), '4 Sep 2026');
      expect(Dates.long(d), 'Friday, 4 September 2026');
      expect(Dates.time(d), '9:00 AM');
    });
  });

  group('Clock', () {
    test('today() strips the time component', () {
      const clock = FixedClock.new;
      expect(clock(DateTime(2026, 9, 4, 23, 59)).today(), DateTime(2026, 9, 4));
    });
  });
}
