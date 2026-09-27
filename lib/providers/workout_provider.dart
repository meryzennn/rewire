import 'package:flutter/foundation.dart';

import '../core/utils/date_utils.dart';
import '../core/utils/xp_utils.dart';
import '../data/routines.dart';
import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';
import '../services/achievement_service.dart';
import '../services/quest_service.dart';
import '../services/xp_service.dart';

/// Provider for bodyweight workout routines, exercises, stats, and session completion (spec §4.1–4.2).
class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider(
    this._workouts,
    this._xp, {
    this.quests,
    this.achievements,
  });

  final WorkoutRepository _workouts;
  final XpService _xp;
  final QuestService? quests;
  final AchievementService? achievements;

  WorkoutRepository get workouts => _workouts;
  XpService get xp => _xp;

  String _selectedCategory = 'Semua';
  int _totalMinutes = 0;
  int _sessionCount = 0;
  bool _isLoadingStats = false;

  String get selectedCategory => _selectedCategory;
  int get totalMinutes => _totalMinutes;
  int get sessionCount => _sessionCount;
  bool get isLoadingStats => _isLoadingStats;

  void setCategory(String category) {
    if (category != _selectedCategory) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  Future<void> loadStats() async {
    _isLoadingStats = true;
    notifyListeners();

    try {
      final totalSeconds = await _workouts.totalCompletedSeconds();
      final count = await _workouts.completedCount();
      _totalMinutes = totalSeconds ~/ 60;
      _sessionCount = count;
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  /// Records a completed workout session, awards XP based on duration brackets,
  /// and triggers quest & achievement checks.
  Future<XpAward> completeWorkout({
    required String routineId,
    required String routineName,
    required int durationSeconds,
    required int exercisesCompleted,
    required int exercisesTotal,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();
    final minutes = (durationSeconds / 60).round();
    final routine = findRoutineById(routineId);
    final effectiveMinutes = minutes > 0 ? minutes : (routine?.durationMinutes ?? 10);
    final xpEarned = xpForWorkoutDurationMinutes(effectiveMinutes);

    final session = WorkoutSession(
      date: formatLocalDate(timestamp),
      routineId: routineId,
      routineName: routineName,
      durationSeconds: durationSeconds,
      exercisesCompleted: exercisesCompleted,
      exercisesTotal: exercisesTotal,
      xpEarned: xpEarned,
    );

    await _workouts.insertSession(session);

    final award = await _xp.award(xpEarned);

    if (quests != null) {
      await quests!.recordActivity(
        QuestActivity.workout,
        timestamp,
        amount: 1,
      );
    }

    if (achievements != null) {
      await achievements!.checkAndUnlock(now: timestamp);
    }

    await loadStats();

    return award;
  }
}
