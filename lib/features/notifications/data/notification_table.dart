import 'package:drift/drift.dart';

import '../../../core/services/notifications/scheduled_reminder.dart';

/// One inbox row per reminder that has actually fired. Populated by
/// reconciliation on launch (see `notification_repository_impl.dart`), not by
/// the OS callback directly — a reminder can fire while the app is killed.
@DataClassName('NotificationRow')
@TableIndex(name: 'notifications_dedupe', columns: {#dedupeKey}, unique: true)
@TableIndex(name: 'notifications_created', columns: {#createdAt})
class Notifications extends Table {
  TextColumn get id => text()();

  IntColumn get kind => intEnum<ReminderKind>()();

  TextColumn get ownerId => text()();

  TextColumn get title => text()();

  TextColumn get body => text().nullable()();

  TextColumn get route => text().nullable()();

  /// `'<kind>:<ownerId>:<fireAt ISO-8601>'` — makes re-running reconciliation
  /// on every launch safe: the same fired moment is never inserted twice.
  TextColumn get dedupeKey => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
