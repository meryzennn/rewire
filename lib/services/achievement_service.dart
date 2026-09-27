import 'dart:math' as math;

import '../core/utils/date_utils.dart';
import '../core/utils/xp_utils.dart';
import '../data/achievements_definitions.dart';
import '../models/achievement.dart';
import '../models/streak.dart';
import '../repositories/achievement_repository.dart';
import '../repositories/checkin_repository.dart';
import '../repositories/meditation_repository.dart';
import '../repositories/quest_repository.dart';
import '../repositories/user_repository.dart';
import '../data/routines.dart';
import '../repositories/workout_repository.dart';

/// Number of distinct workout routines shipped in v1 (spec §4.2). Used by the
/// `full_body` badge ("complete all routines at least once").
final int _kWorkoutRoutineCount = kAllRoutines.length;

/// Evaluates achievement conditions (spec §3.5) and unlocks badges one-time.
class AchievementService {
  AchievementService(
    this._users,
    this._checkins,
    this._meditation,
    this._workouts,
    this._quests,
    this._achievements,
  );

  final UserRepository _users;
  final CheckinRepository _checkins;
  final MeditationRepository _meditation;
  final WorkoutRepository _workouts;
  final QuestRepository _quests;
  final AchievementRepository _achievements;

  /// Returns all achievements, seeding them first if not yet seeded.
  Future<List<Achievement>> getAllAchievements() async {
    await _achievements.seedAll(kAchievementDefinitions);
    return _achievements.getAll();
  }

  /// Seeds definitions (idempotent), evaluates every badge, unlocks any newly
  /// earned ones, and returns those newly unlocked. [now] stamps the unlock date
  /// (injectable for tests; it does not affect which badges unlock).
  Future<List<Achievement>> checkAndUnlock({DateTime? now}) async {
    await _achievements.seedAll(kAchievementDefinitions);
    final date = formatLocalDate(now ?? DateTime.now());

    final conditions = await _evaluate();

    final newly = <Achievement>[];
    for (final def in kAchievementDefinitions) {
      if (conditions[def.badgeId] != true) continue;
      final flipped = await _achievements.unlock(def.badgeId, date);
      if (!flipped) continue;
      final updated = await _achievements.getByBadgeId(def.badgeId);
      if (updated != null) newly.add(updated);
    }
    return newly;
  }

  Future<Map<String, bool>> _evaluate() async {
    final profile = await _users.getOrCreateProfile();
    final level = levelForXp(profile.totalXp);
    final bestStreak = math.max(profile.currentStreak, profile.longestStreak);

    final cleanDays = await _checkins.countByStatus('clean');
    final triggers = await _checkins.triggerCount();
    final medMinutes = (await _meditation.totalCompletedSeconds()) ~/ 60;
    final workoutCount = await _workouts.completedCount();
    final dailyQuestsDone = await _quests.completedCount(type: 'daily');

    final distinctSounds = (await _meditation.getHistory())
        .map((s) => s.audioType)
        .whereType<String>()
        .toSet()
        .length;
    final distinctRoutines = (await _workouts.getHistory())
        .map((w) => w.routineId)
        .toSet()
        .length;
    final maxCheckinRun = _maxConsecutiveDays(
      (await _checkins.getHistory()).map((c) => c.date),
    );
    final bounced = _hasBounced(await _checkins.getStreaks());

    return {
      'first_spark': cleanDays >= 1,
      'week_warrior': bestStreak >= 7,
      'two_weeks': bestStreak >= 14,
      'lunar_cycle': bestStreak >= 30,
      'solar_power': bestStreak >= 90,
      'zen_mind': medMinutes >= 100,
      'deep_focus': medMinutes >= 500,
      'iron_will': workoutCount >= 50,
      'marathon': workoutCount >= 100,
      'consistency': maxCheckinRun >= 30,
      'explorer': distinctSounds >= 6,
      'full_body': distinctRoutines >= _kWorkoutRoutineCount,
      'trigger_aware': triggers >= 20,
      'bouncer': bounced,
      'level_10': level >= 10,
      'level_25': level >= 25,
      'level_50': level >= 50,
      'quest_master': dailyQuestsDone >= 50,
      // early_bird / night_owl are intentionally absent: they need per-event
      // local time-of-day, which the v1 schema does not record. They stay locked
      // until check-in / meditation rows carry a local timestamp.
    };
  }

  /// Longest run of consecutive calendar days across [dates] (yyyy-MM-dd).
  int _maxConsecutiveDays(Iterable<String> dates) {
    final days = dates.map(DateTime.parse).toSet().toList()..sort();
    if (days.isEmpty) return 0;
    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      final gap = calendarDaysBetween(days[i - 1], days[i]);
      run = gap == 1 ? run + 1 : 1;
      best = math.max(best, run);
    }
    return best;
  }

  /// True if a streak resumed within a day of a relapse (spec §3.5 "bouncer").
  // ponytail: "within 24h" is approximated at calendar-day granularity because
  // streak rows store dates, not timestamps. Tighten if streaks gain event times.
  bool _hasBounced(List<Streak> streaks) {
    final relapseEnds = streaks
        .where((s) => s.endedBy == 'relapse' && s.endDate != null)
        .map((s) => DateTime.parse(s.endDate!));
    for (final end in relapseEnds) {
      for (final s in streaks) {
        final start = DateTime.parse(s.startDate);
        final gap = calendarDaysBetween(end, start);
        if (gap >= 0 && gap <= 1) return true;
      }
    }
    return false;
  }
}
