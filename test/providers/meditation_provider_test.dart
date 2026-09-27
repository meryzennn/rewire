import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/providers/meditation_provider.dart';
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
  late QuestRepository quests;
  late AchievementRepository achievements;
  late XpService xp;
  late QuestService questService;
  late AchievementService achievementService;
  late MeditationProvider provider;

  final now = DateTime(2026, 9, 27, 10, 0);

  setUp(() async {
    db = await openTestDatabase();
    users = UserRepository(db);
    checkins = CheckinRepository(db);
    meditation = MeditationRepository(db);
    quests = QuestRepository(db);
    achievements = AchievementRepository(db);
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

    provider = MeditationProvider(
      meditation,
      xp,
      quests: questService,
      achievements: achievementService,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('initial state has default configuration', () {
    expect(provider.selectedDurationMinutes, 10);
    expect(provider.selectedTrackId, 'rain');
    expect(provider.selectedBreathingId, isNull);
    expect(provider.totalMinutes, 0);
    expect(provider.sessionCount, 0);
  });

  test('setters update configuration and notify listeners', () {
    var notified = 0;
    provider.addListener(() => notified++);

    provider.setDuration(15);
    expect(provider.selectedDurationMinutes, 15);
    expect(notified, 1);

    provider.setTrack('waves');
    expect(provider.selectedTrackId, 'waves');
    expect(notified, 2);

    provider.setBreathing('box');
    expect(provider.selectedBreathingId, 'box');
    expect(notified, 3);
  });

  test('completeSession inserts session, awards XP, and updates stats', () async {
    // Refresh quests so daily meditation quests are assigned
    await questService.refreshIfNeeded(now);

    final award = await provider.completeSession(
      durationSeconds: 600, // 10 minutes
      audioType: 'rain',
      breathingType: 'box',
      now: now,
    );

    // 10 minutes gives 15 XP according to spec §3.1
    expect(award.amount, 15);
    expect(award.totalXpAfter, 15);

    // Stats updated in provider
    expect(provider.totalMinutes, 10);
    expect(provider.sessionCount, 1);

    // Verify persisted session in repository
    final history = await meditation.getHistory();
    expect(history.length, 1);
    expect(history.first.durationSeconds, 600);
    expect(history.first.audioType, 'rain');
    expect(history.first.breathingType, 'box');
    expect(history.first.xpEarned, 15);
    expect(history.first.completed, 1);
  });
}
