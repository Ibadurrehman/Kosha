import 'entities/notification_entry.dart';

/// The notification inbox: what fired, grouped Today / Earlier this week /
/// Earlier by the screen, newest first.
abstract interface class NotificationRepository {
  Stream<List<NotificationEntry>> watchInbox();

  Stream<int> watchUnreadCount();

  Future<void> markRead(String id);

  Future<void> markAllRead();

  /// Finds every remindable task/event whose intended fire moment is at or
  /// before [now] and inserts an inbox row for any such moment not already
  /// present. Safe to call on every launch: the unique `dedupeKey` means a
  /// moment already reconciled is never inserted twice, while rescheduling a
  /// task/event to a new time produces a *new* key — the old row stays as a
  /// true record of "this did fire", not a stale duplicate.
  Future<void> reconcile({required DateTime now});
}
