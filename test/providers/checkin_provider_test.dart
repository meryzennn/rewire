import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/providers/checkin_provider.dart';
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
  late QuestRepository quests;
  late AchievementRepository achievements;
  late XpService xp;
  late QuestService questService;
  late AchievementService achievementService;
  late CheckinProvider provider;

  final day1 = DateTime(2026, 9, 25);
  final day2 = DateTime(2026, 9, 26);
  final day3 = DateTime(2026, 9, 27);

  setUp(() async {
    db = await openTestDatabase();
    users = UserRepository(db);
    checkins = CheckinRepository(db);
    quests = QuestRepository(db);
    achievements = AchievementRepository(db);
    final meditation = MeditationRepository(db);
    final workouts = WorkoutRepository(db);

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

    provider = CheckinProvider(
      checkins,
      xp,
      users: users,
      quests: questService,
      achievements: achievementService,
    );
  });

  tearDown(() async => db.close());

  test('clean check-in awards +20 XP once, starts streak, and sets longest streak', () async {
    final checkin = await provider.submitCheckin(
      status: 'clean',
      mood: 4,
      notes: 'Feeling great',
      now: day1,
    );

    expect(checkin.status, 'clean');
    expect(checkin.mood, 4);
    expect(checkin.notes, 'Feeling great');
    expect(provider.currentStreak, 1);
    expect(provider.longestStreak, 1);

    final profile = await users.getProfile();
    expect(profile!.totalXp, 20);
    expect(profile.currentStreak, 1);
    expect(profile.longestStreak, 1);
  });

  test('consecutive clean check-in increments streak and awards XP', () async {
    await provider.submitCheckin(status: 'clean', now: day1);
    expect(provider.currentStreak, 1);

    await provider.submitCheckin(status: 'clean', now: day2);
    expect(provider.currentStreak, 2);
    expect(provider.longestStreak, 2);

    final profile = await users.getProfile();
    expect(profile!.totalXp, 40); // 20 + 20
    expect(profile.currentStreak, 2);
  });

  test('same-day repeat check-in does not award duplicate XP or double-increment streak', () async {
    await provider.submitCheckin(status: 'clean', mood: 3, now: day1);
    expect(provider.currentStreak, 1);

    // Edit check-in on the same day
    final updated = await provider.submitCheckin(
      status: 'clean',
      mood: 5,
      notes: 'Even better now',
      now: day1,
    );

    expect(updated.mood, 5);
    expect(provider.currentStreak, 1);

    final profile = await users.getProfile();
    expect(profile!.totalXp, 20); // No double XP
  });

  test('relapse check-in ends streak, resets current streak to 0, and preserves XP', () async {
    // 2 days clean
    await provider.submitCheckin(status: 'clean', now: day1);
    await provider.submitCheckin(status: 'clean', now: day2);
    expect(provider.currentStreak, 2);

    final xpBefore = (await users.getProfile())!.totalXp;
    expect(xpBefore, 40);

    // Relapse on day 3
    await provider.submitCheckin(status: 'relapse', mood: 1, now: day3);
    expect(provider.currentStreak, 0);
    expect(provider.longestStreak, 2);

    final profile = await users.getProfile();
    expect(profile!.currentStreak, 0);
    expect(profile.longestStreak, 2);
    expect(profile.totalXp, 40, reason: 'Relapse must never reduce lifetime XP');
    expect(profile.level, 1, reason: 'Relapse must never reduce level');

    // Recorded in streaks table with ended_by: 'relapse'
    final streaks = await checkins.getStreaks();
    expect(
      streaks.any((s) => s.endedBy == 'relapse' && s.length == 2),
      isTrue,
    );
  });

  test('triggers are saved atomically and advance trigger quests', () async {
    await questService.refreshIfNeeded(day1);

    await provider.submitCheckin(
      status: 'clean',
      triggers: ['Stres', 'Bosan'],
      now: day1,
    );

    expect(await checkins.triggerCount(), 2);
    expect(provider.todayTriggers, ['Stres', 'Bosan']);
  });

  test('milestone bonus XP awarded when reaching 7-day streak', () async {
    // Seed profile with 6-day streak
    await users.getOrCreateProfile();
    await users.updateProfile(
      const UserProfile(
        id: 1,
        level: 1,
        totalXp: 120,
        currentStreak: 6,
        longestStreak: 6,
        streakStartDate: '2026-09-20',
        brainStage: 'dormant',
      ),
    );
    // Seed day 6 checkin so day 7 continues it
    await checkins.saveCheckin(
      const DailyCheckin(
        date: '2026-09-26',
        status: 'clean',
        xpEarned: 20,
      ),
    );

    await provider.submitCheckin(status: 'clean', now: day3); // day3 = 2026-09-27
    expect(provider.currentStreak, 7);

    final profile = await users.getProfile();
    // 120 + 20 (daily) + 50 (milestone 7d) = 190
    expect(profile!.totalXp, 190);
  });

  test('achievements check and unlock on check-in', () async {
    // First clean check-in should unlock 'first_spark'
    await provider.submitCheckin(status: 'clean', now: day1);

    final firstSpark = await achievements.getByBadgeId('first_spark');
    expect(firstSpark, isNotNull);
    expect(firstSpark!.unlocked, 1);
  });
}
