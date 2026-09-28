import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key names, verbatim from spec §2.5. This is the single
/// place the string keys live, so router, onboarding, settings, and the reset
/// sweep can never drift apart.
class PrefKeys {
  const PrefKeys._();

  static const onboardingCompleted = 'onboarding_completed';
  static const darkMode = 'dark_mode';
  static const language = 'language';
  static const dailyReminderEnabled = 'daily_reminder_enabled';
  static const dailyReminderTime = 'daily_reminder_time';
  static const meditationReminderEnabled = 'meditation_reminder_enabled';
  static const workoutReminderEnabled = 'workout_reminder_enabled';
  static const lastCheckinDate = 'last_checkin_date';
  static const lastQuestRefreshDate = 'last_quest_refresh_date';
  static const lastWeeklyRefreshDate = 'last_weekly_refresh_date';
  static const userName = 'user_name';
  static const userAge = 'user_age';
  static const userHeight = 'user_height';
  static const userWeight = 'user_weight';
  static const userPfpPath = 'user_pfp_path';

  /// Every app-owned key, swept by [PreferenceService.resetAll]. Includes the
  /// date bookkeeping keys later tasks write, so a reset leaves no stale state.
  static const all = <String>[
    onboardingCompleted,
    darkMode,
    language,
    dailyReminderEnabled,
    dailyReminderTime,
    meditationReminderEnabled,
    workoutReminderEnabled,
    lastCheckinDate,
    lastQuestRefreshDate,
    lastWeeklyRefreshDate,
    userName,
    userAge,
    userHeight,
    userWeight,
    userPfpPath,
  ];
}

/// Typed, reactive wrapper over the app's [SharedPreferences] (spec §2.5).
///
/// It is a [ChangeNotifier] so the theme can rebuild live: the settings screen
/// writes through it, `RewireApp` listens for [themeMode]. Getters read the
/// synchronous in-memory cache, so the router's redirect can consult the same
/// store without an async hop. Only §2.5 keys are read or written here.
class PreferenceService extends ChangeNotifier {
  PreferenceService(this._prefs);

  final SharedPreferences _prefs;

  /// Default check-in reminder time when the user has not picked one (§2.5
  /// stores it as an "HH:mm" string).
  static const String defaultReminderTime = '08:00';

  bool get onboardingCompleted =>
      _prefs.getBool(PrefKeys.onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) =>
      _writeBool(PrefKeys.onboardingCompleted, value);

  /// §2.5 stores a single `dark_mode` bool. Unset means "follow the OS", which
  /// keeps Task 6's `ThemeMode.system` default until the user makes a choice.
  ThemeMode get themeMode {
    final dark = _prefs.getBool(PrefKeys.darkMode);
    if (dark == null) return ThemeMode.system;
    return dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool value) => _writeBool(PrefKeys.darkMode, value);

  String get language => _prefs.getString(PrefKeys.language) ?? 'id';

  Future<void> setLanguage(String value) =>
      _writeString(PrefKeys.language, value);

  bool get dailyReminderEnabled =>
      _prefs.getBool(PrefKeys.dailyReminderEnabled) ?? false;

  Future<void> setDailyReminderEnabled(bool value) =>
      _writeBool(PrefKeys.dailyReminderEnabled, value);

  String get dailyReminderTime =>
      _prefs.getString(PrefKeys.dailyReminderTime) ?? defaultReminderTime;

  Future<void> setDailyReminderTime(String hhmm) =>
      _writeString(PrefKeys.dailyReminderTime, hhmm);

  bool get meditationReminderEnabled =>
      _prefs.getBool(PrefKeys.meditationReminderEnabled) ?? false;

  Future<void> setMeditationReminderEnabled(bool value) =>
      _writeBool(PrefKeys.meditationReminderEnabled, value);

  bool get workoutReminderEnabled =>
      _prefs.getBool(PrefKeys.workoutReminderEnabled) ?? false;

  Future<void> setWorkoutReminderEnabled(bool value) =>
      _writeBool(PrefKeys.workoutReminderEnabled, value);

  String get userName => _prefs.getString(PrefKeys.userName) ?? '';

  Future<void> setUserName(String value) =>
      _writeString(PrefKeys.userName, value);

  int? get userAge => _prefs.getInt(PrefKeys.userAge);

  Future<void> setUserAge(int? value) async {
    if (value == null) {
      await _prefs.remove(PrefKeys.userAge);
    } else {
      await _prefs.setInt(PrefKeys.userAge, value);
    }
    notifyListeners();
  }

  double? get userHeight => _prefs.getDouble(PrefKeys.userHeight);

  Future<void> setUserHeight(double? value) async {
    if (value == null) {
      await _prefs.remove(PrefKeys.userHeight);
    } else {
      await _prefs.setDouble(PrefKeys.userHeight, value);
    }
    notifyListeners();
  }

  double? get userWeight => _prefs.getDouble(PrefKeys.userWeight);

  Future<void> setUserWeight(double? value) async {
    if (value == null) {
      await _prefs.remove(PrefKeys.userWeight);
    } else {
      await _prefs.setDouble(PrefKeys.userWeight, value);
    }
    notifyListeners();
  }

  String? get userPfpPath => _prefs.getString(PrefKeys.userPfpPath);

  Future<void> setUserPfpPath(String? value) async {
    if (value == null) {
      await _prefs.remove(PrefKeys.userPfpPath);
    } else {
      await _prefs.setString(PrefKeys.userPfpPath, value);
    }
    notifyListeners();
  }

  /// Clears every app-owned pref (§2.5). The DB wipe is a separate step owned
  /// by the caller; this only touches preferences.
  Future<void> resetAll() async {
    for (final key in PrefKeys.all) {
      await _prefs.remove(key);
    }
    notifyListeners();
  }

  Future<void> _writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
    notifyListeners();
  }

  Future<void> _writeString(String key, String value) async {
    await _prefs.setString(key, value);
    notifyListeners();
  }
}
