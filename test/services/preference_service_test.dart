import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds a service over a freshly mocked SharedPreferences.
Future<PreferenceService> _service([Map<String, Object> seed = const {}]) async {
  SharedPreferences.setMockInitialValues(seed);
  final prefs = await SharedPreferences.getInstance();
  return PreferenceService(prefs);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('theme mode (only the dark_mode bool, spec §2.5)', () {
    test('unset falls back to system', () async {
      final service = await _service();
      expect(service.themeMode, ThemeMode.system);
    });

    test('dark_mode=true is dark, false is light', () async {
      expect((await _service({'dark_mode': true})).themeMode, ThemeMode.dark);
      expect((await _service({'dark_mode': false})).themeMode, ThemeMode.light);
    });

    test('setDarkMode persists and drives themeMode', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      await service.setDarkMode(true);
      expect(prefs.getBool('dark_mode'), true);
      // A second service over the same store reads the persisted value.
      expect(PreferenceService(prefs).themeMode, ThemeMode.dark);
    });
  });

  group('reminders persist through prefs (spec §2.5 keys)', () {
    test('daily reminder toggle + time round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      expect(service.dailyReminderEnabled, false);
      expect(service.dailyReminderTime, '08:00');

      await service.setDailyReminderEnabled(true);
      await service.setDailyReminderTime('21:30');

      expect(prefs.getBool('daily_reminder_enabled'), true);
      expect(prefs.getString('daily_reminder_time'), '21:30');
      expect(PreferenceService(prefs).dailyReminderTime, '21:30');
    });

    test('meditation + workout reminder toggles round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      await service.setMeditationReminderEnabled(true);
      await service.setWorkoutReminderEnabled(true);

      expect(prefs.getBool('meditation_reminder_enabled'), true);
      expect(prefs.getBool('workout_reminder_enabled'), true);
    });
  });

  group('onboarding flag', () {
    test('defaults false, persists true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      expect(service.onboardingCompleted, false);
      await service.setOnboardingCompleted(true);
      expect(prefs.getBool('onboarding_completed'), true);
    });
  });

  group('resetAll clears every owned key', () {
    test('all §2.5 keys removed, getters back to defaults', () async {
      SharedPreferences.setMockInitialValues({
        'onboarding_completed': true,
        'dark_mode': true,
        'daily_reminder_enabled': true,
        'daily_reminder_time': '21:30',
        'meditation_reminder_enabled': true,
        'workout_reminder_enabled': true,
        'last_checkin_date': '2026-09-27',
        'last_quest_refresh_date': '2026-09-27',
        'last_weekly_refresh_date': '2026-09-27',
      });
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      await service.resetAll();

      expect(service.onboardingCompleted, false);
      expect(service.themeMode, ThemeMode.system);
      expect(service.dailyReminderEnabled, false);
      expect(prefs.getKeys(), isEmpty);
    });
  });

  test('setters notify listeners', () async {
    final service = await _service();
    var notified = 0;
    service.addListener(() => notified++);
    await service.setDarkMode(true);
    await service.setDailyReminderEnabled(true);
    await service.resetAll();
    expect(notified, greaterThanOrEqualTo(3));
  });
}
