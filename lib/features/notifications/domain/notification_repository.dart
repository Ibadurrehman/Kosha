import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/notification_entry.dart';

/// The notification inbox: what fired, grouped Today / Earlier this week /
/// Earlier by the screen, newest first.
abstract interface class NotificationRepository {
  Stream<List<NotificationEntry>> watchInbox();

  Stream<int> watchUnreadCount();

  Future<void> markRead(String id);

  Future<void> markAllRead();

  /// Marks every row about one record read — what "acting on it clears the
  /// notification" means (section 6.7's acceptance for paying a bill).
  ///
  /// The rows stay in the inbox: the reminder genuinely did fire, and the
  /// inbox is a record of what happened, not a to-do list. Reading them is
  /// the part that should follow from dealing with the thing itself.
  Future<void> markReadForOwner(ReminderKind kind, String ownerId);

  /// Finds every remindable task/event whose intended fire moment is at or
  /// before [now] and inserts an inbox row for any such moment not already
  /// present. Safe to call on every launch: the unique `dedupeKey` means a
  /// moment already reconciled is never inserted twice, while rescheduling a
  /// task/event to a new time produces a *new* key — the old row stays as a
  /// true record of "this did fire", not a stale duplicate.
  Future<void> reconcile({required DateTime now});
}
