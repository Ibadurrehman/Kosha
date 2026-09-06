/// Calendar-day arithmetic on local dates.
///
/// `DateTime.add(Duration(days: n))` adds exactly `n × 24 h`, which is not the
/// same as "n days later" in any timezone that observes daylight saving: on a
/// spring-forward day midnight + 24 h lands at 01:00 the next day, and on a
/// fall-back day it lands at 23:00 the *same* day. Dart's own documentation
/// warns that the result "may not even hit the calendar date it was intended
/// to".
///
/// Every day-step in this app goes through [addDays] instead, which rebuilds
/// the date from calendar parts and lets `DateTime` normalise it — the same
/// approach `DriftTaskRepository._bucketPredicate` already took for the
/// Today/Overdue boundary. India, the v1 locale, has no DST, so this is about
/// being correct rather than about a bug users are hitting today.
library;

/// Midnight at the start of [value]'s day, in local time.
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// [days] calendar days after [value] (or before it, when negative), keeping
/// the time of day. Month, year and leap-day boundaries are handled by
/// `DateTime`'s own normalisation: 31 Dec + 1 day is 1 Jan, 28 Feb + 1 day is
/// 29 Feb in a leap year and 1 Mar otherwise.
DateTime addDays(DateTime value, int days) => DateTime(
      value.year,
      value.month,
      value.day + days,
      value.hour,
      value.minute,
      value.second,
      value.millisecond,
      value.microsecond,
    );

/// [weeks] calendar weeks after [value]. Shorthand for seven-day steps.
DateTime addWeeks(DateTime value, int weeks) => addDays(value, weeks * 7);
