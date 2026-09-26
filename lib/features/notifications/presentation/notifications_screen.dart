import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/notification_repository_impl.dart';
import '../domain/entities/notification_entry.dart';
import '../domain/notification_grouping.dart';
import 'controllers/notification_providers.dart';

IconData _iconFor(ReminderKind kind) => switch (kind) {
      ReminderKind.task => Symbols.task_alt_rounded,
      ReminderKind.event => Symbols.event_rounded,
      ReminderKind.bill => Symbols.receipt_long_rounded,
      ReminderKind.document => Symbols.folder_shared_rounded,
      ReminderKind.vehicleRenewal => Symbols.directions_car_rounded,
      ReminderKind.appliance => Symbols.home_repair_service_rounded,
      ReminderKind.customRecord => Symbols.dataset_rounded,
      ReminderKind.general => Symbols.notifications_rounded,
    };

/// Grouped Today / Earlier this week / Earlier, newest first within each
/// group, unread dot, "Mark all read".
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(inboxProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => unawaited(
              ref.read(notificationRepositoryProvider).markAllRead(),
            ),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: entries.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load notifications",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(inboxProvider),
        ),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Symbols.notifications_rounded,
                title: 'Nothing yet',
                body: 'Reminders that fire will collect here.',
              )
            : _Grouped(entries: list),
      ),
    );
  }
}

class _Grouped extends ConsumerWidget {
  const _Grouped({required this.entries});

  final List<NotificationEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(clockProvider).today();
    final groups = <NotificationGroup, List<NotificationEntry>>{};
    for (final entry in entries) {
      (groups[notificationGroupFor(entry.createdAt, today)] ??= []).add(entry);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        8,
        KoshaSpace.screen,
        24,
      ),
      children: [
        for (final group in NotificationGroup.values)
          if (groups[group] case final list? when list.isNotEmpty) ...[
            SectionLabel(group.label),
            for (final entry in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _NotificationRow(entry: entry),
              ),
          ],
      ],
    );
  }
}

class _NotificationRow extends ConsumerWidget {
  const _NotificationRow({required this.entry});

  final NotificationEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: () => unawaited(_open(context, ref)),
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              IconTile(_iconFor(entry.kind)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title, style: t.titleSmall),
                    if (entry.body case final body? when body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(body, style: t.bodySmall),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Dates.dayMonth(entry.createdAt), style: t.labelSmall),
                  const SizedBox(height: 6),
                  if (entry.isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    await ref.read(notificationRepositoryProvider).markRead(entry.id);
    final route = entry.route;
    if (route != null && context.mounted) context.go(route);
  }
}
