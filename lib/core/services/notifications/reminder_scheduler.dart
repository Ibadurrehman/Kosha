import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

import 'scheduled_reminder.dart';

part 'reminder_scheduler.g.dart';

/// Schedules and cancels the local notifications behind every due date in the
/// app. Repositories call this after a write so every entry point behaves the
/// same, and tests swap in [NoopReminderScheduler].
abstract interface class ReminderScheduler {
  /// Replaces any reminder already scheduled for the same owner.
  Future<void> schedule(ScheduledReminder reminder);

  Future<void> cancel(ReminderKind kind, String ownerId);

  /// Asks the platform for notification permission. Safe to call more than
  /// once; returns false when the user has declined.
  Future<bool> requestPermission();
}

/// Used in tests and on platforms where notifications are not wired up.
class NoopReminderScheduler implements ReminderScheduler {
  const NoopReminderScheduler();

  @override
  Future<void> schedule(ScheduledReminder reminder) async {}

  @override
  Future<void> cancel(ReminderKind kind, String ownerId) async {}

  @override
  Future<bool> requestPermission() async => false;
}

/// Backed by `flutter_local_notifications`.
///
/// Scheduling is inexact by default so the app does not need the Android
/// `SCHEDULE_EXACT_ALARM` permission; an "Exact reminders" setting can opt in
/// later. Initialisation is lazy and memoised, so the plugin is only touched
/// once something is actually scheduled.
class LocalNotificationsReminderScheduler implements ReminderScheduler {
  LocalNotificationsReminderScheduler([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  Future<void> _ensureReady() => _ready ??= _initialize();

  Future<void> _initialize() async {
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object catch (error) {
      // Falls back to the timezone database default; reminders still fire,
      // just against UTC if the platform could not name its zone.
      debugPrint('Kosha: could not resolve the local timezone ($error)');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          // Asked for explicitly through requestPermission() instead, so the
          // prompt appears when the user first sets a reminder.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<void> schedule(ScheduledReminder reminder) async {
    await _ensureReady();
    await cancel(reminder.kind, reminder.ownerId);
    await _plugin.zonedSchedule(
      id: reminder.notificationId,
      title: reminder.title,
      body: reminder.body,
      payload: reminder.route,
      scheduledDate: tz.TZDateTime.from(reminder.fireAt, tz.local),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          reminder.kind.channelId,
          reminder.kind.channelName,
          channelDescription: reminder.kind.channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Future<void> cancel(ReminderKind kind, String ownerId) async {
    await _ensureReady();
    await _plugin.cancel(id: reminderNotificationId(kind, ownerId));
  }

  @override
  Future<bool> requestPermission() async {
    await _ensureReady();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final darwin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (darwin != null) {
      return await darwin.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }
}

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) =>
    LocalNotificationsReminderScheduler();
