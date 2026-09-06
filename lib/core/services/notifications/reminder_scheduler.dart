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

  /// Asks Android for the `SCHEDULE_EXACT_ALARM` permission (D9); a no-op
  /// that returns true on platforms without the concept, since their
  /// reminders already fire at the exact moment.
  Future<bool> requestExactAlarmsPermission();

  /// Switches every reminder scheduled from now on between exact and
  /// inexact delivery. Does not touch reminders already scheduled — the
  /// caller re-schedules those (e.g. via `resyncReminders()`) if it wants
  /// the new mode to apply retroactively.
  Future<void> setExactAlarmsEnabled(bool enabled);

  /// The route payload of every OS notification the user taps, including one
  /// that launched the app cold. `app.dart` listens once and deep-links.
  Stream<String> get notificationTaps;
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

  @override
  Future<bool> requestExactAlarmsPermission() async => true;

  @override
  Future<void> setExactAlarmsEnabled(bool enabled) async {}

  @override
  Stream<String> get notificationTaps => const Stream.empty();
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
  final StreamController<String> _taps = StreamController<String>.broadcast();
  bool _exactAlarmsEnabled = false;

  @override
  Stream<String> get notificationTaps => _taps.stream;

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
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _taps.add(payload);
      },
    );
    // A tap that launched the app cold arrives here instead of the callback
    // above, which only fires for a running process.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      if (payload != null && payload.isNotEmpty) _taps.add(payload);
    }
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
      androidScheduleMode: _exactAlarmsEnabled
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
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

  @override
  Future<bool> requestExactAlarmsPermission() async {
    await _ensureReady();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // iOS (and every other platform) has no separate exact-alarm concept —
    // its reminders already fire at the exact moment requested.
    if (android == null) return true;
    return await android.requestExactAlarmsPermission() ?? false;
  }

  @override
  Future<void> setExactAlarmsEnabled(bool enabled) async {
    _exactAlarmsEnabled = enabled;
  }
}

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) =>
    LocalNotificationsReminderScheduler();
