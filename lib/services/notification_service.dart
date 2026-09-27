import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'preference_service.dart';

/// Adapter interface wrapping [FlutterLocalNotificationsPlugin] for testability
/// without hitting Android platform channels (spec §8, Task 13).
abstract class NotificationPluginAdapter {
  Future<bool?> initialize({
    required AndroidInitializationSettings androidSettings,
  });

  Future<bool?> requestPermission();

  Future<void> zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode androidScheduleMode,
    DateTimeComponents? matchDateTimeComponents,
  });

  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
  });

  Future<void> cancel(int id);

  Future<void> cancelAll();
}

/// Default implementation delegating to real [FlutterLocalNotificationsPlugin].
class DefaultNotificationPluginAdapter implements NotificationPluginAdapter {
  DefaultNotificationPluginAdapter([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<bool?> initialize({
    required AndroidInitializationSettings androidSettings,
  }) {
    final settings = InitializationSettings(android: androidSettings);
    return _plugin.initialize(settings);
  }

  @override
  Future<bool?> requestPermission() async {
    return await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode androidScheduleMode,
    DateTimeComponents? matchDateTimeComponents,
  }) {
    return _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: androidScheduleMode,
      matchDateTimeComponents: matchDateTimeComponents,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
  }) {
    return _plugin.show(id, title, body, notificationDetails);
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();
}

/// Service managing offline local notification reminders and instant alerts
/// (spec §8). Uses Android notification channel "rewire_reminders" and timezone-
/// safe daily schedules.
class NotificationService {
  NotificationService({NotificationPluginAdapter? adapter})
    : _adapter = adapter ?? DefaultNotificationPluginAdapter();

  final NotificationPluginAdapter _adapter;

  // Channel constants (spec §8)
  static const String channelId = 'rewire_reminders';
  static const String channelName = 'Pengingat Rewire';
  static const String channelDescription =
      'Notifikasi pengingat harian check-in, meditasi, dan olahraga';

  // Notification IDs (fixed for deterministic rescheduling/cancellation)
  static const int dailyReminderId = 1001;
  static const int meditationReminderId = 1002;
  static const int workoutReminderId = 1003;
  static const int instantNotificationId = 2001;

  // Indonesian notification copy
  static const String dailyReminderTitle = 'Waktunya Check-in Harian ✨';
  static const String dailyReminderBody =
      'Bagaimana kabarmu hari ini? Catat progres pemulihanmu.';

  static const String meditationReminderTitle = 'Waktunya Meditasi 🧘';
  static const String meditationReminderBody =
      'Ambil jeda sejenak untuk menenangkan pikiranmu.';

  static const String workoutReminderTitle = 'Waktunya Olahraga 💪';
  static const String workoutReminderBody =
      'Lepaskan ketegangan fisik dan perkuat tubuhmu.';

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidDetails,
  );

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initializes timezone data, sets local timezone offset, and registers
  /// Android notification channel.
  Future<bool> initialize() async {
    try {
      tz_data.initializeTimeZones();
      _configureLocalTimezone();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      final result = await _adapter.initialize(androidSettings: androidSettings);
      _initialized = true;
      return result ?? true;
    } catch (_) {
      _initialized = false;
      return false;
    }
  }

  /// Finds timezone matching current device UTC offset without extra dependencies.
  void _configureLocalTimezone() {
    try {
      final now = DateTime.now();
      final offsetMs = now.timeZoneOffset.inMilliseconds;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == offsetMs) {
          tz.setLocalLocation(loc);
          return;
        }
      }
      tz.setLocalLocation(tz.getLocation('UTC'));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }
  }

  /// Requests notification permission on Android 13+ (POST_NOTIFICATIONS).
  Future<bool?> requestPermission() => _adapter.requestPermission();

  /// Calculates next instance of the specified [TimeOfDay] in local timezone.
  tz.TZDateTime nextInstanceOfTime(TimeOfDay time, {DateTime? nowOverride}) {
    final now = nowOverride != null
        ? tz.TZDateTime.from(nowOverride, tz.local)
        : tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Parses "HH:mm" formatted string to [TimeOfDay].
  static TimeOfDay parseHhmm(String hhmm) {
    final parts = hhmm.split(':');
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Schedules recurring daily check-in reminder.
  Future<void> scheduleDailyReminder([
    TimeOfDay time = const TimeOfDay(hour: 8, minute: 0),
  ]) async {
    await _adapter.zonedSchedule(
      id: dailyReminderId,
      title: dailyReminderTitle,
      body: dailyReminderBody,
      scheduledDate: nextInstanceOfTime(time),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules recurring daily meditation reminder.
  Future<void> scheduleMeditationReminder([
    TimeOfDay time = const TimeOfDay(hour: 12, minute: 0),
  ]) async {
    await _adapter.zonedSchedule(
      id: meditationReminderId,
      title: meditationReminderTitle,
      body: meditationReminderBody,
      scheduledDate: nextInstanceOfTime(time),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules recurring daily workout reminder.
  Future<void> scheduleWorkoutReminder([
    TimeOfDay time = const TimeOfDay(hour: 17, minute: 0),
  ]) async {
    await _adapter.zonedSchedule(
      id: workoutReminderId,
      title: workoutReminderTitle,
      body: workoutReminderBody,
      scheduledDate: nextInstanceOfTime(time),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels daily check-in reminder.
  Future<void> cancelDailyReminder() => _adapter.cancel(dailyReminderId);

  /// Cancels meditation reminder.
  Future<void> cancelMeditationReminder() =>
      _adapter.cancel(meditationReminderId);

  /// Cancels workout reminder.
  Future<void> cancelWorkoutReminder() => _adapter.cancel(workoutReminderId);

  /// Cancels all scheduled and active notifications.
  Future<void> cancelAll() => _adapter.cancelAll();

  /// Displays an instant one-off notification (e.g. for level-ups or alerts).
  Future<void> showInstant(
    String title,
    String body, {
    int id = instantNotificationId,
  }) async {
    await _adapter.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails,
    );
  }

  /// Synchronizes scheduled notifications with stored preferences.
  Future<void> syncWithPreferences(PreferenceService preferences) async {
    try {
      if (preferences.dailyReminderEnabled) {
        final time = parseHhmm(preferences.dailyReminderTime);
        await scheduleDailyReminder(time);
      } else {
        await cancelDailyReminder();
      }

      if (preferences.meditationReminderEnabled) {
        await scheduleMeditationReminder();
      } else {
        await cancelMeditationReminder();
      }

      if (preferences.workoutReminderEnabled) {
        await scheduleWorkoutReminder();
      } else {
        await cancelWorkoutReminder();
      }
    } catch (_) {
      // Ignored: notification sync should not crash app startup
    }
  }
}
