import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/services/settings/settings_store.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/widgets/kosha_toggle.dart';
import '../../bills/data/bill_repository_impl.dart';
import '../../calendar/data/event_repository_impl.dart';
import '../../tasks/data/task_repository_impl.dart';
import '../domain/notification_settings.dart';
import 'appearance_screen.dart';
import 'controllers/settings_providers.dart';
import 'customize_dashboard_screen.dart';
import 'profile_screen.dart';

/// The 7 groups from the prototype. Only Account → Profile, Appearance,
/// Notifications → Task reminders and Dashboard → Customize are real; the
/// rest render as static rows naming the phase they arrive in, matching
/// gaps G21–G23.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(KoshaSpace.screen),
        children: [
          _Group(
            title: 'Account',
            rows: [
              _Row.link(
                icon: Symbols.person_rounded,
                label: 'Profile',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                ),
              ),
              const _Row.later(icon: Symbols.mail_rounded, label: 'Email', phase: 'Phase 4'),
              const _Row.later(
                icon: Symbols.fingerprint_rounded,
                label: 'Security',
                phase: 'Phase 6',
              ),
            ],
          ),
          _Group(
            title: 'Appearance',
            rows: [
              _Row.link(
                icon: Symbols.dark_mode_rounded,
                label: 'Theme',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AppearanceScreen()),
                ),
              ),
            ],
          ),
          const _Group(
            title: 'Notifications',
            rows: [
              _TaskRemindersRow(),
              _BillRemindersRow(),
              _ExactRemindersRow(),
              _Row.later(icon: Symbols.receipt_long_rounded, label: 'Bills lead', phase: 'Phase 2'),
              _Row.later(
                icon: Symbols.folder_shared_rounded,
                label: 'Documents lead',
                phase: 'Phase 3',
              ),
              _Row.later(
                icon: Symbols.autorenew_rounded,
                label: 'Subscriptions lead',
                phase: 'Phase 2',
              ),
            ],
          ),
          _Group(
            title: 'Dashboard',
            rows: [
              _Row.link(
                icon: Symbols.dashboard_customize_rounded,
                label: 'Customize dashboard',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CustomizeDashboardScreen(),
                  ),
                ),
              ),
            ],
          ),
          const _Group(
            title: 'Data',
            rows: [
              _Row.later(icon: Symbols.upload_rounded, label: 'Export', phase: 'Phase 6'),
              _Row.later(icon: Symbols.download_rounded, label: 'Import', phase: 'Phase 6'),
              _Row.later(icon: Symbols.cloud_done_rounded, label: 'Backup', phase: 'Phase 4'),
              _Row.later(icon: Symbols.inventory_2_rounded, label: 'Archive', phase: 'Phase 4'),
            ],
          ),
          const _Group(
            title: 'Privacy & security',
            rows: [
              _Row.later(icon: Symbols.lock_rounded, label: 'App lock', phase: 'Phase 6'),
              _Row.later(
                icon: Symbols.fingerprint_rounded,
                label: 'Biometric unlock',
                phase: 'Phase 6',
              ),
              _Row.later(
                icon: Symbols.shield_rounded,
                label: 'Data privacy',
                phase: 'Phase 6',
              ),
            ],
          ),
          const _Group(
            title: 'General',
            rows: [
              _Row.later(
                icon: Symbols.currency_rupee_rounded,
                label: 'Currency',
                phase: 'Phase 6',
              ),
              _Row.later(icon: Symbols.event_rounded, label: 'Date format', phase: 'Phase 6'),
              _Row.later(
                icon: Symbols.calendar_view_week_rounded,
                label: 'Start of week',
                phase: 'Phase 6',
              ),
              _Row.later(icon: Symbols.language_rounded, label: 'Language', phase: 'Phase 6'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KoshaRadius.card),
              side: BorderSide(color: c.border),
            ),
            child: Column(
              children: [
                for (final (index, row) in rows.indexed) ...[
                  if (index > 0) Divider(height: 1, color: c.hair),
                  row,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row.link({required this.icon, required this.label, required VoidCallback this.onTap})
      : phase = null;

  const _Row.later({required this.icon, required this.label, required this.phase})
      : onTap = null;

  final IconData icon;
  final String label;
  final String? phase;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return ListTile(
      enabled: onTap != null,
      leading: Icon(icon, color: c.text2),
      title: Text(label),
      trailing: phase != null
          ? Text(phase!, style: t.labelSmall)
          : Icon(Symbols.chevron_right_rounded, color: c.text3),
      onTap: onTap,
    );
  }
}

class _TaskRemindersRow extends ConsumerWidget {
  const _TaskRemindersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final enabled = ref.watch(taskRemindersEnabledProvider).value ?? true;
    return ListTile(
      leading: Icon(Symbols.task_alt_rounded, color: c.text2),
      title: const Text('Task reminders'),
      trailing: KoshaToggle(
        value: enabled,
        semanticLabel: 'Task reminders',
        onChanged: (value) => unawaited(_toggle(ref, value)),
      ),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool enabled) async {
    final store = ref.read(settingsStoreProvider);
    await writeTaskRemindersEnabled(store, enabled: enabled);
    ref.invalidate(taskRemindersEnabledProvider);

    final repository = ref.read(taskRepositoryProvider);
    if (enabled) {
      await repository.resyncReminders();
    } else {
      final scheduler = ref.read(reminderSchedulerProvider);
      for (final task in await repository.remindable()) {
        await scheduler.cancel(ReminderKind.task, task.id);
      }
    }
  }
}

/// The same shape as [_TaskRemindersRow]: turning it off cancels what is
/// already scheduled rather than waiting for the next launch's resync, and
/// turning it back on re-states every bill that still owes money.
class _BillRemindersRow extends ConsumerWidget {
  const _BillRemindersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final enabled = ref.watch(billRemindersEnabledProvider).value ?? true;
    return ListTile(
      leading: Icon(Symbols.receipt_long_rounded, color: c.text2),
      title: const Text('Bill reminders'),
      trailing: KoshaToggle(
        value: enabled,
        semanticLabel: 'Bill reminders',
        onChanged: (value) => unawaited(_toggle(ref, value)),
      ),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool enabled) async {
    final store = ref.read(settingsStoreProvider);
    await writeBillRemindersEnabled(store, enabled: enabled);
    ref.invalidate(billRemindersEnabledProvider);

    final repository = ref.read(billRepositoryProvider);
    if (enabled) {
      await repository.resyncReminders();
    } else {
      await repository.cancelReminders();
    }
  }
}

/// D9: opt in to exact (`SCHEDULE_EXACT_ALARM`) delivery instead of the
/// battery-friendly inexact default. Declining the Android permission prompt
/// leaves the setting off, matching [_TaskRemindersRow]'s own no-throw style.
class _ExactRemindersRow extends ConsumerWidget {
  const _ExactRemindersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final enabled = ref.watch(exactRemindersEnabledProvider).value ?? false;
    return ListTile(
      leading: Icon(Symbols.alarm_on_rounded, color: c.text2),
      title: const Text('Exact reminders'),
      subtitle: const Text('Uses more battery; falls back if permission is declined'),
      trailing: KoshaToggle(
        value: enabled,
        semanticLabel: 'Exact reminders',
        onChanged: (value) => unawaited(_toggle(ref, value)),
      ),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool enabled) async {
    final scheduler = ref.read(reminderSchedulerProvider);
    if (enabled) {
      final granted = await scheduler.requestExactAlarmsPermission();
      if (!granted) return;
    }

    final store = ref.read(settingsStoreProvider);
    await writeExactRemindersEnabled(store, enabled: enabled);
    await scheduler.setExactAlarmsEnabled(enabled);
    ref.invalidate(exactRemindersEnabledProvider);

    final tasksEnabled = await readTaskRemindersEnabled(store);
    if (tasksEnabled) await ref.read(taskRepositoryProvider).resyncReminders();
    await ref.read(eventRepositoryProvider).resyncReminders();
    final billsEnabled = await readBillRemindersEnabled(store);
    if (billsEnabled) await ref.read(billRepositoryProvider).resyncReminders();
  }
}
