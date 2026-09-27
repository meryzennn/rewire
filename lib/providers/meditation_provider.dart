import 'package:flutter/foundation.dart';

import '../core/utils/date_utils.dart';
import '../core/utils/xp_utils.dart';
import '../models/meditation_session.dart';
import '../repositories/meditation_repository.dart';
import '../services/achievement_service.dart';
import '../services/quest_service.dart';
import '../services/xp_service.dart';

/// Provider for meditation configuration, stats, and session completion.
class MeditationProvider extends ChangeNotifier {
  MeditationProvider(
    this._meditation,
    this._xp, {
    this.quests,
    this.achievements,
  });

  final MeditationRepository _meditation;
  final XpService _xp;
  final QuestService? quests;
  final AchievementService? achievements;

  MeditationRepository get meditation => _meditation;
  XpService get xp => _xp;

  int _selectedDurationMinutes = 10;
  String _selectedTrackId = 'rain';
  String? _selectedBreathingId;

  int _totalMinutes = 0;
  int _sessionCount = 0;
  bool _isLoadingStats = false;

  int get selectedDurationMinutes => _selectedDurationMinutes;
  String get selectedTrackId => _selectedTrackId;
  String? get selectedBreathingId => _selectedBreathingId;

  int get totalMinutes => _totalMinutes;
  int get sessionCount => _sessionCount;
  bool get isLoadingStats => _isLoadingStats;

  void setDuration(int minutes) {
    if (minutes > 0 && minutes != _selectedDurationMinutes) {
      _selectedDurationMinutes = minutes;
      notifyListeners();
    }
  }

  void setTrack(String trackId) {
    if (trackId != _selectedTrackId) {
      _selectedTrackId = trackId;
      notifyListeners();
    }
  }

  void setBreathing(String? breathingId) {
    if (breathingId != _selectedBreathingId) {
      _selectedBreathingId = breathingId;
      notifyListeners();
    }
  }

  Future<void> loadStats() async {
    _isLoadingStats = true;
    notifyListeners();

    try {
      final totalSeconds = await _meditation.totalCompletedSeconds();
      final count = await _meditation.completedCount();
      _totalMinutes = totalSeconds ~/ 60;
      _sessionCount = count;
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  /// Records a completed meditation session, awards XP, and updates quests/achievements.
  Future<XpAward> completeSession({
    required int durationSeconds,
    required String? audioType,
    required String? breathingType,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();
    final minutes = (durationSeconds / 60).round();
    final xpEarned = xpForMeditationMinutes(minutes);

    final session = MeditationSession(
      date: formatLocalDate(timestamp),
      durationSeconds: durationSeconds,
      audioType: audioType,
      breathingType: breathingType,
      xpEarned: xpEarned,
      completed: 1,
    );

    await _meditation.insertSession(session);

    final award = await _xp.award(xpEarned);

    if (quests != null && minutes > 0) {
      await quests!.recordActivity(
        QuestActivity.meditation,
        timestamp,
        amount: minutes,
      );
    }

    if (achievements != null) {
      await achievements!.checkAndUnlock(now: timestamp);
    }

    await loadStats();

    return award;
  }
}
