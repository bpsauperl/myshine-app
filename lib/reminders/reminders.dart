import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'reminder_plan.dart';

/// Puts the aligner reminders on the phone and takes them off again.
abstract class Reminders {
  /// Whether the patient wants reminders (Profile). On unless turned off.
  Future<bool> isEnabled();

  Future<void> setEnabled(bool enabled);

  /// Replaces the scheduled reminders with [plan]. The first time there is
  /// something to remind of, the phone asks the patient for permission.
  Future<void> replace(List<PlannedReminder> plan);

  /// After disconnecting: nothing more to remind of.
  Future<void> cancelAll();
}

/// No reminders (web, tests).
class NoReminders implements Reminders {
  const NoReminders();

  @override
  Future<bool> isEnabled() async => false;

  @override
  Future<void> setEnabled(bool enabled) async {}

  @override
  Future<void> replace(List<PlannedReminder> plan) async {}

  @override
  Future<void> cancelAll() async {}
}

/// Local notifications: they work without a server or a push token.
class LocalReminders implements Reminders {
  LocalReminders({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _offKey = 'myshine_reminders_off';
  static const _askedKey = 'myshine_reminders_asked';

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'aligner_changes',
      'Aligner changes',
      channelDescription: 'When to put in your next aligner.',
    ),
    iOS: DarwinNotificationDetails(),
  );

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  Future<void> _init() => _ready ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      )
      .then((_) {});

  @override
  Future<bool> isEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_offKey) != true;

  @override
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offKey, !enabled);
    if (enabled) {
      await prefs.remove(_askedKey);
    } else {
      await cancelAll();
    }
  }

  @override
  Future<void> replace(List<PlannedReminder> plan) async {
    try {
      await _init();
      await _plugin.cancelAll();
      if (plan.isEmpty || !await isEnabled()) {
        return;
      }
      await _askOnce();
      for (final reminder in plan) {
        await _plugin.zonedSchedule(
          id: reminder.id,
          title: reminder.title,
          body: reminder.body,
          // The moment in UTC, so no time zone database is needed.
          scheduledDate: tz.TZDateTime.from(reminder.at, tz.UTC),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      // A reminder that can't be set must never break the app.
      debugPrint('Reminders: $e');
    }
  }

  Future<void> _askOnce() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_askedKey) == true) {
      return;
    }
    await prefs.setBool(_askedKey, true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: false, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> cancelAll() async {
    try {
      await _init();
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Reminders: $e');
    }
  }
}
