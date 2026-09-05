import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Injectable source of "now" so date-bucket logic (Today / Overdue / Upcoming)
/// can be tested across midnight, DST and timezone changes.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

class FixedClock implements Clock {
  const FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

final clockProvider = Provider<Clock>((_) => const SystemClock());

extension ClockDates on Clock {
  /// Midnight at the start of today in local time.
  DateTime today() {
    final n = now();
    return DateTime(n.year, n.month, n.day);
  }
}
