import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds a service over a freshly mocked SharedPreferences.
Future<PreferenceService> _service([
  Map<String, Object> seed = const {},
]) async {
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
        'user_name': 'Budi',
        'user_age': 25,
        'user_height': 175.0,
        'user_weight': 70.0,
        'user_pfp_path': '/path/to/pfp.jpg',
        'user_birth_date': '1998-05-20',
        'user_fitness_level': 'expert',
      });
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      await service.resetAll();

      expect(service.onboardingCompleted, false);
      expect(service.themeMode, ThemeMode.system);
      expect(service.dailyReminderEnabled, false);
      expect(service.userName, '');
      expect(service.userAge, isNull);
      expect(service.userBirthDate, isNull);
      expect(service.userBirthYear, isNull);
      expect(service.userFitnessLevel, 'beginner');
      expect(service.userHeight, isNull);
      expect(service.userWeight, isNull);
      expect(service.userPfpPath, isNull);
      expect(prefs.getKeys(), isEmpty);
    });
  });

  group('profile fields round-trip', () {
    test('name, age, height, weight, and pfp path round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      expect(service.userName, '');
      expect(service.userAge, isNull);
      expect(service.userHeight, isNull);
      expect(service.userWeight, isNull);
      expect(service.userPfpPath, isNull);

      await service.setUserName('Budi Rewire');
      await service.setUserAge(28);
      await service.setUserHeight(175.5);
      await service.setUserWeight(68.0);
      await service.setUserPfpPath('/data/user/0/pfp.png');

      expect(service.userName, 'Budi Rewire');
      expect(service.userAge, 28);
      expect(service.userHeight, 175.5);
      expect(service.userWeight, 68.0);
      expect(service.userPfpPath, '/data/user/0/pfp.png');

      // Test clearing nullables
      await service.setUserAge(null);
      await service.setUserHeight(null);
      await service.setUserWeight(null);
      await service.setUserPfpPath(null);

      expect(service.userAge, isNull);
      expect(service.userHeight, isNull);
      expect(service.userWeight, isNull);
      expect(service.userPfpPath, isNull);
    });

    test('userBirthDate, userBirthYear, and dynamic userAge round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      expect(service.userBirthDate, isNull);
      expect(service.userBirthYear, isNull);
      expect(service.userAge, isNull);

      final birthDate = DateTime(1998, 5, 20);
      await service.setUserBirthDate(birthDate);

      expect(service.userBirthDate, isNotNull);
      expect(service.userBirthDate!.year, 1998);
      expect(service.userBirthDate!.month, 5);
      expect(service.userBirthDate!.day, 20);
      expect(service.userBirthYear, 1998);

      // Verify dynamic userAge calculation from birth date
      final now = DateTime.now();
      var expectedAge = now.year - 1998;
      if (now.month < 5 || (now.month == 5 && now.day < 20)) {
        expectedAge--;
      }
      expect(service.userAge, expectedAge);

      // Clearing birth date restores fallback to stored userAge or null
      await service.setUserBirthDate(null);
      expect(service.userBirthDate, isNull);
      expect(service.userBirthYear, isNull);
      expect(service.userAge, isNull);

      // Explicit userAge fallback when birthDate is null
      await service.setUserAge(30);
      expect(service.userAge, 30);
    });

    test('userFitnessLevel defaults to beginner and round-trips', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = PreferenceService(prefs);

      expect(service.userFitnessLevel, 'beginner');

      await service.setUserFitnessLevel('intermediate');
      expect(service.userFitnessLevel, 'intermediate');

      await service.setUserFitnessLevel('expert');
      expect(service.userFitnessLevel, 'expert');
    });
  });

  test('setters notify listeners', () async {
    final service = await _service();
    var notified = 0;
    service.addListener(() => notified++);
    await service.setDarkMode(true);
    await service.setDailyReminderEnabled(true);
    await service.setUserName('Test');
    await service.setUserAge(20);
    await service.setUserBirthDate(DateTime(1995, 10, 10));
    await service.setUserFitnessLevel('expert');
    await service.resetAll();
    expect(notified, greaterThanOrEqualTo(7));
  });

  group('language preference', () {
    test('defaults to en', () async {
      final service = await _service();
      expect(service.language, 'en');
    });

    test('setLanguage persists and notifies', () async {
      final service = await _service();
      var notified = false;
      service.addListener(() => notified = true);

      await service.setLanguage('id');
      expect(service.language, 'id');
      expect(notified, isTrue);

      await service.resetAll();
      expect(service.language, 'en');
    });
  });
}
