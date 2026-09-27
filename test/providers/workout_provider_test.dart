import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/providers/workout_provider.dart';
import 'package:rewire/repositories/achievement_repository.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:rewire/repositories/meditation_repository.dart';
import 'package:rewire/repositories/quest_repository.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:rewire/repositories/workout_repository.dart';
import 'package:rewire/services/achievement_service.dart';
import 'package:rewire/services/quest_service.dart';
import 'package:rewire/services/xp_service.dart';
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
  late XpService xp;
  late QuestService questService;
  late AchievementService achievementService;
  late WorkoutProvider provider;

  final now = DateTime(2026, 9, 27, 10, 0);

  setUp(() async {
    db = await openTestDatabase();
    users = UserRepository(db);
    checkins = CheckinRepository(db);
    meditation = MeditationRepository(db);
    workouts = WorkoutRepository(db);
    quests = QuestRepository(db);
    achievements = AchievementRepository(db);

    xp = XpService(users, checkins);
    questService = QuestService(quests, xp);
    achievementService = AchievementService(
      users,
      checkins,
      meditation,
      workouts,
      quests,
      achievements,
    );

    provider = WorkoutProvider(
      workouts,
      xp,
      quests: questService,
      achievements: achievementService,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('initial state has default configuration', () {
    expect(provider.selectedCategory, 'Semua');
    expect(provider.totalMinutes, 0);
    expect(provider.sessionCount, 0);
  });

  test('setCategory updates category and notifies listeners', () {
    var notified = 0;
    provider.addListener(() => notified++);

    provider.setCategory('Upper');
    expect(provider.selectedCategory, 'Upper');
    expect(notified, 1);

    provider.setCategory('Upper'); // no-op if same
    expect(notified, 1);
  });

  test('completeWorkout inserts session, awards XP, and updates stats', () async {
    await questService.refreshIfNeeded(now);

    final award = await provider.completeWorkout(
      routineId: 'morning_energy',
      routineName: 'Morning Energy',
      durationSeconds: 900, // 15 minutes -> 25 XP (spec §3.1)
      exercisesCompleted: 6,
      exercisesTotal: 6,
      now: now,
    );

    expect(award.amount, 25);
    expect(award.totalXpAfter, 25);

    expect(provider.totalMinutes, 15);
    expect(provider.sessionCount, 1);

    final history = await workouts.getHistory();
    expect(history.length, 1);
    expect(history.first.routineId, 'morning_energy');
    expect(history.first.routineName, 'Morning Energy');
    expect(history.first.durationSeconds, 900);
    expect(history.first.exercisesCompleted, 6);
    expect(history.first.exercisesTotal, 6);
    expect(history.first.xpEarned, 25);
  });
}
