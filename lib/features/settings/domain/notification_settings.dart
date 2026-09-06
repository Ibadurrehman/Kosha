import '../../../core/services/settings/settings_store.dart';

/// Whether task reminders may be scheduled at all. Bills/Documents/
/// Subscriptions leads (section 6.17) don't exist yet, so this is the one
/// real row in Settings' Notifications group.
const String taskRemindersEnabledKey = 'notifications.task_reminders_enabled';

Future<bool> readTaskRemindersEnabled(SettingsStore store) async {
  final stored = await store.read(taskRemindersEnabledKey, (json) => json as bool);
  return stored ?? true;
}

Future<void> writeTaskRemindersEnabled(SettingsStore store, {required bool enabled}) =>
    store.write(taskRemindersEnabledKey, enabled);

/// Whether reminders should ask Android for `SCHEDULE_EXACT_ALARM` and fire
/// at the exact moment instead of the inexact, battery-friendly default
/// (D9). Off by default; iOS ignores this since its reminders are already
/// exact.
const String exactRemindersEnabledKey = 'notifications.exact_reminders_enabled';

Future<bool> readExactRemindersEnabled(SettingsStore store) async {
  final stored = await store.read(exactRemindersEnabledKey, (json) => json as bool);
  return stored ?? false;
}

Future<void> writeExactRemindersEnabled(SettingsStore store, {required bool enabled}) =>
    store.write(exactRemindersEnabledKey, enabled);
