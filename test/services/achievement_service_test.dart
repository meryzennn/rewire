import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/achievements_definitions.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/meditation_session.dart';
import 'package:rewire/models/streak.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/models/workout_session.dart';
import 'package:rewire/repositories/achievement_repository.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:rewire/repositories/meditation_repository.dart';
import 'package:rewire/repositories/quest_repository.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:rewire/repositories/workout_repository.dart';
import 'package:rewire/services/achievement_service.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/repository_test_db.dart';

void main() {
  late Database db;
  late UserRepository users;
  late CheckinRepository checkins;
  late MeditationRepository meditation;
  late WorkoutRepository workouts;
  late QuestRepository quests;
  late AchievementRepository achievements;
  late AchievementService service;

  setUp(() async {
    db = await openTestDatabase();
    users = UserRepository(db);
    checkins = CheckinRepository(db);
    meditation = MeditationRepository(db);
    workouts = WorkoutRepository(db);
    quests = QuestRepository(db);
    achievements = AchievementRepository(db);
    service = AchievementService(
      users,
      checkins,
      meditation,
      workouts,
      quests,
      achievements,
    );
    await users.getOrCreateProfile();
  });

  tearDown(() async => db.close());

  Future<void> setStreak({int current = 0, int longest = 0}) async {
    await users.updateProfile(
      UserProfile(
        level: 1,
        totalXp: 0,
        currentStreak: current,
        longestStreak: longest,
        brainStage: 'dormant',
      ),
    );
  }

  test('definitions cover all 20 badges from spec §3.5', () {
    expect(kAchievementDefinitions.length, 20);
    expect(
      kAchievementDefinitions.map((a) => a.badgeId).toSet(),
      containsAll({
        'first_spark', 'week_warrior', 'two_weeks', 'lunar_cycle',
        'solar_power', 'zen_mind', 'deep_focus', 'iron_will', 'marathon',
        'early_bird', 'night_owl', 'consistency', 'explorer', 'full_body',
        'trigger_aware', 'bouncer', 'level_10', 'level_25', 'level_50',
        'quest_master',
      }),
    );
  });

  test('first_spark unlocks after one clean check-in', () async {
    await checkins.upsertCheckin(
      const DailyCheckin(date: '2026-09-27', status: 'clean', xpEarned: 20),
    );
    final unlocked = await service.checkAndUnlock();
    expect(unlocked.map((a) => a.badgeId), contains('first_spark'));

    // One-time: a second check does not re-report it.
    final again = await service.checkAndUnlock();
    expect(again.map((a) => a.badgeId), isNot(contains('first_spark')));
  });

  test('streak milestones unlock at their thresholds', () async {
    await setStreak(current: 7, longest: 7);
    var unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('week_warrior'));
    expect(unlocked, isNot(contains('two_weeks')));

    await setStreak(current: 30, longest: 30);
    unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, containsAll({'two_weeks', 'lunar_cycle'}));
  });

  test('meditation-minute badges use total completed minutes', () async {
    for (var i = 0; i < 20; i++) {
      await meditation.insertSession(
        MeditationSession(
          date: '2026-09-${(i % 28) + 1}',
          durationSeconds: 300, // 5 min each -> 100 min total
          completed: 1,
          xpEarned: 10,
        ),
      );
    }
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('zen_mind'));
    expect(unlocked, isNot(contains('deep_focus')));
  });

  test('workout-count and level badges unlock', () async {
    for (var i = 0; i < 50; i++) {
      await workouts.insertSession(
        WorkoutSession(
          date: '2026-09-27',
          routineId: 'r$i',
          routineName: 'R',
          durationSeconds: 600,
          exercisesCompleted: 5,
          exercisesTotal: 5,
          xpEarned: 15,
        ),
      );
    }
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('iron_will'));
    expect(unlocked, isNot(contains('marathon')));
  });

  test('explorer unlocks after all 6 ambient sounds are tried', () async {
    for (final t in ['rain', 'ocean', 'forest', 'whitenoise', 'lofi', 'campfire']) {
      await meditation.insertSession(
        MeditationSession(
          date: '2026-09-27',
          durationSeconds: 60,
          audioType: t,
          completed: 1,
          xpEarned: 10,
        ),
      );
    }
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('explorer'));
  });

  test('trigger_aware unlocks at 20 logged triggers', () async {
    for (var i = 0; i < 20; i++) {
      final day = (i + 1).toString().padLeft(2, '0');
      await checkins.saveCheckin(
        DailyCheckin(date: '2026-09-$day', status: 'clean', xpEarned: 0),
        triggers: ['t$i'],
      );
    }
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('trigger_aware'));
  });

  test('time-of-day badges stay locked (schema has no local event time)',
      () async {
    // early_bird and night_owl require per-event local time not tracked in v1.
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, isNot(contains('early_bird')));
    expect(unlocked, isNot(contains('night_owl')));
  });

  test('bouncer unlocks when a streak resumes within a day of relapse',
      () async {
    await checkins.insertStreak(
      const Streak(
        startDate: '2026-09-01',
        endDate: '2026-09-10',
        length: 9,
        endedBy: 'relapse',
      ),
    );
    await checkins.insertStreak(
      const Streak(startDate: '2026-09-11', length: 1, endedBy: 'active'),
    );
    final unlocked = (await service.checkAndUnlock()).map((a) => a.badgeId);
    expect(unlocked, contains('bouncer'));
  });

  test('seeding is idempotent and all definitions become queryable', () async {
    await service.checkAndUnlock();
    await service.checkAndUnlock();
    expect((await achievements.getAll()).length, 20);
  });
}
