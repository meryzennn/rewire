import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/services/notification_service.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class ScheduledCall {
  ScheduledCall({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    required this.notificationDetails,
    required this.androidScheduleMode,
    this.matchDateTimeComponents,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledDate;
  final NotificationDetails notificationDetails;
  final AndroidScheduleMode androidScheduleMode;
  final DateTimeComponents? matchDateTimeComponents;
}

class ShownCall {
  ShownCall({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationDetails,
  });

  final int id;
  final String title;
  final String body;
  final NotificationDetails notificationDetails;
}

class FakeNotificationPluginAdapter implements NotificationPluginAdapter {
  bool initialized = false;
  int requestPermissionCount = 0;
  final List<ScheduledCall> scheduled = [];
  final List<ShownCall> shown = [];
  final List<int> canceledIds = [];
  int cancelAllCount = 0;

  @override
  Future<bool?> initialize({
    required AndroidInitializationSettings androidSettings,
  }) async {
    initialized = true;
    return true;
  }

  @override
  Future<bool?> requestPermission() async {
    requestPermissionCount++;
    return true;
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
  }) async {
    scheduled.add(
      ScheduledCall(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: androidScheduleMode,
        matchDateTimeComponents: matchDateTimeComponents,
      ),
    );
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
  }) async {
    shown.add(
      ShownCall(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      ),
    );
  }

  @override
  Future<void> cancel(int id) async {
    canceledIds.add(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCount++;
  }
}

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  late FakeNotificationPluginAdapter adapter;
  late NotificationService service;

  setUp(() {
    adapter = FakeNotificationPluginAdapter();
    service = NotificationService(adapter: adapter);
  });

  group('NotificationService lifecycle and permissions', () {
    test('initialize sets isInitialized and calls adapter', () async {
      expect(service.isInitialized, isFalse);
      final result = await service.initialize();
      expect(result, isTrue);
      expect(service.isInitialized, isTrue);
      expect(adapter.initialized, isTrue);
    });

    test('requestPermission delegates to adapter', () async {
      expect(adapter.requestPermissionCount, 0);
      final res = await service.requestPermission();
      expect(res, isTrue);
      expect(adapter.requestPermissionCount, 1);
    });
  });

  group('Schedule reminders', () {
    test(
      'scheduleDailyReminder uses id 1001 and daily reminder copy',
      () async {
        await service.initialize();
        await service.scheduleDailyReminder(
          const TimeOfDay(hour: 7, minute: 30),
        );

        expect(adapter.scheduled.length, 1);
        final call = adapter.scheduled.first;
        expect(call.id, NotificationService.dailyReminderId);
        expect(call.title, NotificationService.dailyReminderTitle);
        expect(call.body, NotificationService.dailyReminderBody);
        expect(call.matchDateTimeComponents, DateTimeComponents.time);
        expect(
          call.androidScheduleMode,
          AndroidScheduleMode.exactAllowWhileIdle,
        );
        expect(call.scheduledDate.hour, 7);
        expect(call.scheduledDate.minute, 30);
      },
    );

    test(
      'scheduleMeditationReminder uses id 1002 and meditation copy',
      () async {
        await service.initialize();
        await service.scheduleMeditationReminder(
          const TimeOfDay(hour: 13, minute: 0),
        );

        expect(adapter.scheduled.length, 1);
        final call = adapter.scheduled.first;
        expect(call.id, NotificationService.meditationReminderId);
        expect(call.title, NotificationService.meditationReminderTitle);
        expect(call.body, NotificationService.meditationReminderBody);
        expect(call.scheduledDate.hour, 13);
        expect(call.scheduledDate.minute, 0);
      },
    );

    test('scheduleWorkoutReminder uses id 1003 and workout copy', () async {
      await service.initialize();
      await service.scheduleWorkoutReminder(
        const TimeOfDay(hour: 18, minute: 15),
      );

      expect(adapter.scheduled.length, 1);
      final call = adapter.scheduled.first;
      expect(call.id, NotificationService.workoutReminderId);
      expect(call.title, NotificationService.workoutReminderTitle);
      expect(call.body, NotificationService.workoutReminderBody);
      expect(call.scheduledDate.hour, 18);
      expect(call.scheduledDate.minute, 15);
    });
  });

  group('Next instance calculation', () {
    test('nextInstanceOfTime schedules today if time is in future', () {
      final base = DateTime(2026, 9, 27, 8, 0);
      final next = service.nextInstanceOfTime(
        const TimeOfDay(hour: 9, minute: 30),
        nowOverride: base,
      );
      expect(next.day, 27);
      expect(next.hour, 9);
      expect(next.minute, 30);
    });

    test('nextInstanceOfTime schedules tomorrow if time is in past', () {
      final base = DateTime(2026, 9, 27, 10, 0);
      final next = service.nextInstanceOfTime(
        const TimeOfDay(hour: 7, minute: 0),
        nowOverride: base,
      );
      expect(next.day, 28);
      expect(next.hour, 7);
      expect(next.minute, 0);
    });
  });

  group('Cancellations and instant notifications', () {
    test('cancel methods delegate correct IDs to adapter', () async {
      await service.cancelDailyReminder();
      await service.cancelMeditationReminder();
      await service.cancelWorkoutReminder();

      expect(adapter.canceledIds, [
        NotificationService.dailyReminderId,
        NotificationService.meditationReminderId,
        NotificationService.workoutReminderId,
      ]);
    });

    test('cancelAll delegates to adapter', () async {
      expect(adapter.cancelAllCount, 0);
      await service.cancelAll();
      expect(adapter.cancelAllCount, 1);
    });

    test('showInstant triggers instant notification with id 2001', () async {
      await service.showInstant('Level Up! 🎉', 'Otakmu mencapai Stage 2!');

      expect(adapter.shown.length, 1);
      final call = adapter.shown.first;
      expect(call.id, NotificationService.instantNotificationId);
      expect(call.title, 'Level Up! 🎉');
      expect(call.body, 'Otakmu mencapai Stage 2!');
    });
  });

  group('syncWithPreferences', () {
    test('syncs enabled and disabled states with preferences', () async {
      SharedPreferences.setMockInitialValues({
        PrefKeys.dailyReminderEnabled: true,
        PrefKeys.dailyReminderTime: '06:45',
        PrefKeys.meditationReminderEnabled: false,
        PrefKeys.workoutReminderEnabled: true,
      });

      final prefs = await SharedPreferences.getInstance();
      final prefService = PreferenceService(prefs);

      await service.syncWithPreferences(prefService);

      // daily enabled -> scheduled 06:45
      // meditation disabled -> canceled
      // workout enabled -> scheduled 17:00
      expect(
        adapter.scheduled.map((e) => e.id),
        containsAll([
          NotificationService.dailyReminderId,
          NotificationService.workoutReminderId,
        ]),
      );
      expect(
        adapter.canceledIds,
        contains(NotificationService.meditationReminderId),
      );

      final dailyCall = adapter.scheduled.firstWhere(
        (e) => e.id == NotificationService.dailyReminderId,
      );
      expect(dailyCall.scheduledDate.hour, 6);
      expect(dailyCall.scheduledDate.minute, 45);
    });
  });

  group('parseHhmm helper', () {
    test('parses HH:mm correctly and handles malformed strings gracefully', () {
      final t1 = NotificationService.parseHhmm('08:30');
      expect(t1.hour, 8);
      expect(t1.minute, 30);

      final t2 = NotificationService.parseHhmm('21:05');
      expect(t2.hour, 21);
      expect(t2.minute, 5);

      final t3 = NotificationService.parseHhmm('invalid');
      expect(t3.hour, 8);
      expect(t3.minute, 0);
    });
  });
}
