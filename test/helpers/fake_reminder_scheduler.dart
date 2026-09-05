import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';

/// Records what the repository asked the operating system to do, so tests can
/// assert on reminders without a platform.
class RecordingReminderScheduler implements ReminderScheduler {
  final List<ScheduledReminder> scheduled = <ScheduledReminder>[];
  final List<String> cancelled = <String>[];

  /// The most recent reminder scheduled for [ownerId], or null if the last
  /// thing that happened to it was a cancellation.
  ScheduledReminder? latestFor(String ownerId) {
    final matches = scheduled.where((r) => r.ownerId == ownerId);
    return matches.isEmpty ? null : matches.last;
  }

  void clear() {
    scheduled.clear();
    cancelled.clear();
  }

  @override
  Future<void> schedule(ScheduledReminder reminder) async {
    scheduled.add(reminder);
  }

  @override
  Future<void> cancel(ReminderKind kind, String ownerId) async {
    cancelled.add(ownerId);
  }

  @override
  Future<bool> requestPermission() async => true;

  @override
  Stream<String> get notificationTaps => const Stream.empty();
}
