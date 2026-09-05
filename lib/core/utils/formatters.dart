import 'package:intl/intl.dart';

/// Money is stored as integer minor units (paise). These helpers render it.
abstract final class Money {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrWithPaise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// `₹2,00,000` — rounds to whole rupees, matching the prototype's `inr()`.
  static String inr(int paise) => _inr.format((paise.abs() / 100).round());

  /// `₹1,850.50` — used on detail screens where paise matter.
  static String inrExact(int paise) => _inrWithPaise.format(paise / 100);
}

abstract final class Dates {
  static final DateFormat _dayMonth = DateFormat('d MMM');
  static final DateFormat _dayMonthYear = DateFormat('d MMM yyyy');
  static final DateFormat _long = DateFormat('EEEE, d MMMM yyyy');
  static final DateFormat _time = DateFormat('h:mm a');

  /// `10 Sep`
  static String dayMonth(DateTime d) => _dayMonth.format(d);

  /// `10 Sep 2026` — the profile default `DD MMM YYYY`.
  static String dayMonthYear(DateTime d) => _dayMonthYear.format(d);

  /// `Friday, 4 September 2026`
  static String long(DateTime d) => _long.format(d);

  /// `9:00 AM`
  static String time(DateTime d) => _time.format(d);
}
