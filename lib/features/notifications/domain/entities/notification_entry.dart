import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/services/notifications/scheduled_reminder.dart';

part 'notification_entry.freezed.dart';

/// One inbox row — a reminder that actually fired, reconciled in on launch
/// (see `notification_repository_impl.dart`'s `reconcile`).
@freezed
abstract class NotificationEntry with _$NotificationEntry {
  const factory NotificationEntry({
    required String id,
    required ReminderKind kind,
    required String ownerId,
    required String title,
    required DateTime createdAt,
    String? body,
    String? route,
    DateTime? readAt,
  }) = _NotificationEntry;

  const NotificationEntry._();

  bool get isUnread => readAt == null;
}
