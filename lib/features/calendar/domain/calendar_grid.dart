/// Pure date arithmetic behind the Month grid and Week strip — no provider,
/// no widget, so it is trivial to unit test across month/year boundaries.
library;

/// The 42 cells (6 full weeks, Monday-first) a month grid shows for the month
/// containing [anyDayInMonth], always spilling into the neighbouring months
/// so the grid never has a ragged row.
List<DateTime> monthGridDays(DateTime anyDayInMonth) {
  final first = DateTime(anyDayInMonth.year, anyDayInMonth.month, 1);
  final leading = (first.weekday - DateTime.monday) % 7;
  final start = first.subtract(Duration(days: leading));
  return [for (var i = 0; i < 42; i++) start.add(Duration(days: i))];
}

/// The 7 days (Monday-first) of the week containing [anyDayInWeek].
List<DateTime> weekDays(DateTime anyDayInWeek) {
  final day = DateTime(anyDayInWeek.year, anyDayInWeek.month, anyDayInWeek.day);
  final leading = (day.weekday - DateTime.monday) % 7;
  final start = day.subtract(Duration(days: leading));
  return [for (var i = 0; i < 7; i++) start.add(Duration(days: i))];
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
