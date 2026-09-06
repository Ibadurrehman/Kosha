/// Recurrence for tasks, bills and renewals.
///
/// Rules are stored as RFC 5545 strings without the `RRULE:` prefix, so a
/// custom-rule editor can widen this later without a data migration. The
/// presets below are what the app can create today, and [Recurrence.nextAfter]
/// computes their occurrences with calendar arithmetic rather than a full
/// RFC engine: a personal task app wants a monthly task on the 31st to land on
/// 28 February, where RFC 5545 would skip the month entirely.
library;

import '../../utils/dates.dart';

/// The repeat options the UI offers.
enum RecurrencePreset {
  never('Never'),
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly'),
  quarterly('Quarterly'),
  yearly('Yearly');

  const RecurrencePreset(this.label);

  final String label;
}

abstract final class Recurrence {
  /// Builds the rule for [preset], anchored on [start].
  ///
  /// Monthly and quarterly rules carry `BYMONTHDAY` so a series never drifts:
  /// a task on the 30th clamps to 28 February and returns to the 30th in March,
  /// instead of staying on the 28th. A task on the last day of its month gets
  /// `BYMONTHDAY=-1` and so always lands on the last day.
  static String? ruleFor(RecurrencePreset preset, {DateTime? start}) {
    switch (preset) {
      case RecurrencePreset.never:
        return null;
      case RecurrencePreset.daily:
        return 'FREQ=DAILY';
      case RecurrencePreset.weekly:
        return 'FREQ=WEEKLY';
      case RecurrencePreset.monthly:
        return 'FREQ=MONTHLY;BYMONTHDAY=${_anchorDay(start)}';
      case RecurrencePreset.quarterly:
        return 'FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=${_anchorDay(start)}';
      case RecurrencePreset.yearly:
        return 'FREQ=YEARLY';
    }
  }

  /// The preset a stored rule came from, or [RecurrencePreset.never] when the
  /// rule is absent. Unrecognised rules report as monthly-style repeats only if
  /// they parse; anything else falls back to [RecurrencePreset.never].
  static RecurrencePreset presetOf(String? rule) {
    final parts = _parse(rule);
    if (parts == null) return RecurrencePreset.never;
    final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
    return switch (parts['FREQ']) {
      'DAILY' => RecurrencePreset.daily,
      'WEEKLY' => RecurrencePreset.weekly,
      'MONTHLY' =>
        interval == 3 ? RecurrencePreset.quarterly : RecurrencePreset.monthly,
      'YEARLY' => RecurrencePreset.yearly,
      _ => RecurrencePreset.never,
    };
  }

  /// Short label for a stored rule, e.g. "Daily".
  static String label(String? rule) => presetOf(rule).label;

  /// The first occurrence strictly after [from], or null when [rule] is not a
  /// repeat this app understands. [from] and the result are local dates.
  static DateTime? nextAfter(String? rule, DateTime from) {
    final parts = _parse(rule);
    if (parts == null) return null;
    final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
    if (interval < 1) return null;
    final date = DateTime(from.year, from.month, from.day);

    switch (parts['FREQ']) {
      case 'DAILY':
        return addDays(date, interval);
      case 'WEEKLY':
        return addWeeks(date, interval);
      case 'MONTHLY':
        final anchor = int.tryParse(parts['BYMONTHDAY'] ?? '') ?? date.day;
        return _addMonths(date, interval, anchorDay: anchor);
      case 'YEARLY':
        return _addMonths(date, 12 * interval, anchorDay: date.day);
      default:
        return null;
    }
  }

  /// `-1` when [start] is the last day of its month, otherwise its day number.
  static int _anchorDay(DateTime? start) {
    if (start == null) return 1;
    return start.day == _daysInMonth(start.year, start.month) ? -1 : start.day;
  }

  /// Adds whole months, putting the result on [anchorDay] and clamping to the
  /// length of the target month. `-1` means the last day of that month.
  static DateTime _addMonths(DateTime date, int months, {required int anchorDay}) {
    final total = date.month - 1 + months;
    final year = date.year + (total ~/ 12);
    final month = (total % 12) + 1;
    final length = _daysInMonth(year, month);
    final day = anchorDay == -1 ? length : anchorDay.clamp(1, length);
    return DateTime(year, month, day);
  }

  static int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  /// Splits `FREQ=MONTHLY;INTERVAL=3` into a map. Returns null for a rule that
  /// carries no frequency.
  static Map<String, String>? _parse(String? rule) {
    if (rule == null || rule.trim().isEmpty) return null;
    final body = rule.trim().toUpperCase().replaceFirst('RRULE:', '');
    final parts = <String, String>{};
    for (final piece in body.split(';')) {
      final index = piece.indexOf('=');
      if (index <= 0) continue;
      parts[piece.substring(0, index)] = piece.substring(index + 1);
    }
    return parts.containsKey('FREQ') ? parts : null;
  }
}
