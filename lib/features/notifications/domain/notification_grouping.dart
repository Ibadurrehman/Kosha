import '../../../core/utils/dates.dart';

/// Which bucket the Notifications screen sorts a row into.
enum NotificationGroup {
  today('Today'),
  earlierThisWeek('Earlier this week'),
  earlier('Earlier');

  const NotificationGroup(this.label);

  final String label;
}

/// [today] is local midnight. A row from today is [NotificationGroup.today];
/// one from the 6 days before that is "earlier this week"; anything older is
/// just "earlier".
NotificationGroup notificationGroupFor(DateTime createdAt, DateTime today) {
  final day = dateOnly(createdAt);
  if (day == today) return NotificationGroup.today;
  final weekAgo = addDays(today, -7);
  if (day.isAfter(weekAgo)) return NotificationGroup.earlierThisWeek;
  return NotificationGroup.earlier;
}
