import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/notification_repository_impl.dart';
import '../../domain/entities/notification_entry.dart';

part 'notification_providers.g.dart';

@riverpod
Stream<List<NotificationEntry>> inbox(Ref ref) =>
    ref.watch(notificationRepositoryProvider).watchInbox();

/// Feeds Home's bell badge.
@riverpod
Stream<int> unreadNotificationCount(Ref ref) =>
    ref.watch(notificationRepositoryProvider).watchUnreadCount();
