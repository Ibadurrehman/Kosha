import 'package:flutter/foundation.dart';

/// What a reminder is about. Each kind gets its own Android channel so a user
/// can mute one class of reminder without losing the rest.
///
/// Persisted by index (`notification_table.dart`'s `kind` column) — append
/// only, new kinds go at the end.
enum ReminderKind {
  task('kosha_tasks', 'Tasks', 'Task and reminder due times'),
  bill('kosha_bills', 'Bills', 'Bills and subscriptions falling due'),
  document('kosha_documents', 'Documents', 'Documents nearing expiry'),
  event('kosha_events', 'Events', 'Calendar events and appointments'),
  general('kosha_general', 'General', 'Everything else Kosha reminds you of'),
  vehicleRenewal(
    'kosha_vehicle',
    'Vehicle',
    'Insurance, PUC and other renewals coming due',
  ),
  appliance('kosha_appliances', 'Appliances', 'Appliance warranties expiring');

  const ReminderKind(this.channelId, this.channelName, this.channelDescription);

  final String channelId;
  final String channelName;
  final String channelDescription;
}

/// One notification the app wants the operating system to deliver later.
@immutable
class ScheduledReminder {
  const ScheduledReminder({
    required this.kind,
    required this.ownerId,
    required this.title,
    required this.fireAt,
    this.body,
    this.route,
  });

  final ReminderKind kind;

  /// The row this reminder belongs to; cancelling uses the same pair.
  final String ownerId;
  final String title;
  final String? body;

  /// Local wall-clock time to fire at.
  final DateTime fireAt;

  /// Deep link to open when tapped, e.g. `/tasks/<id>`.
  final String? route;

  int get notificationId => reminderNotificationId(kind, ownerId);

  @override
  bool operator ==(Object other) =>
      other is ScheduledReminder &&
      other.kind == kind &&
      other.ownerId == ownerId &&
      other.title == title &&
      other.body == body &&
      other.fireAt == fireAt &&
      other.route == route;

  @override
  int get hashCode => Object.hash(kind, ownerId, title, body, fireAt, route);

  @override
  String toString() =>
      'ScheduledReminder(${kind.name}:$ownerId at $fireAt — $title)';
}

/// A notification id that survives restarts, so a reminder scheduled in one
/// session can be cancelled in the next.
///
/// `String.hashCode` is not stable across runs, so this uses FNV-1a and masks
/// to a positive 31-bit int, which is what the platform APIs accept.
int reminderNotificationId(ReminderKind kind, String ownerId) {
  const int offsetBasis = 0x811c9dc5;
  const int prime = 0x01000193;
  var hash = offsetBasis;
  for (final unit in '${kind.name}:$ownerId'.codeUnits) {
    hash = ((hash ^ unit) * prime) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}
