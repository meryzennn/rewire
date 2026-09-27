import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/app.dart';
import 'package:rewire/core/database/database_helper.dart';
import 'package:rewire/core/utils/date_utils.dart';
import 'package:rewire/data/quests_definitions.dart';
import 'package:rewire/data/routines.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/providers/checkin_provider.dart';
import 'package:rewire/providers/meditation_provider.dart';
import 'package:rewire/providers/quest_provider.dart';
import 'package:rewire/providers/user_provider.dart';
import 'package:rewire/providers/workout_provider.dart';
import 'package:rewire/repositories/achievement_repository.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:rewire/repositories/meditation_repository.dart';
import 'package:rewire/repositories/quest_repository.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:rewire/repositories/workout_repository.dart';
import 'package:rewire/screens/checkin/checkin_screen.dart';
import 'package:rewire/screens/home/widgets/brain_visual.dart';
import 'package:rewire/services/achievement_service.dart';
import 'package:rewire/services/notification_service.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:rewire/services/quest_service.dart';
import 'package:rewire/services/xp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/timezone.dart' as tz;

class FakeNotificationPluginAdapter implements NotificationPluginAdapter {
  @override
  Future<bool?> initialize({
    required AndroidInitializationSettings androidSettings,
  }) async => true;

  @override
  Future<bool?> requestPermission() async => true;

  @override
  Future<void> zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode androidScheduleMode,
    DateTimeComponents? matchDateTimeComponents,
  }) async {}

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
  }) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}

Future<Database> _getTestDatabase() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final db = await DatabaseHelper.instance.database;
  await DatabaseHelper.instance.resetData();
  return db;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Rewire Core Recovery Journeys (Integration)', () {
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
    late NotificationService notificationService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({kOnboardingCompletedKey: true});
      final prefs = await SharedPreferences.getInstance();
      final preferenceService = PreferenceService(prefs);

      db = await _getTestDatabase();
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

      notificationService = NotificationService(
        adapter: FakeNotificationPluginAdapter(),
      );
      await notificationService.initialize();
      await notificationService.syncWithPreferences(preferenceService);
    });

    testWidgets(
      'Flow 1: Check-in -> XP awarded, daily check-in quest completed, streak updated',
      (tester) async {
        final now = DateTime(2026, 9, 27, 10, 0);
        final dateStr = formatLocalDate(now);

        // 1. Seed active daily quests
        await questService.refreshIfNeeded(now);

        final userProvider = UserProvider(users, xp);
        await userProvider.loadProfile();

        final questProvider = QuestProvider(questService);
        await questProvider.loadAllQuests(now: now);

        final checkinProvider = CheckinProvider(
          checkins,
          xp,
          users: users,
          quests: questService,
          achievements: achievementService,
        );
        await checkinProvider.loadToday(now: now);

        // Initial state assertions
        expect(userProvider.totalXp, 0);
        expect(userProvider.level, 1);
        expect(checkinProvider.currentStreak, 0);
        expect(checkinProvider.hasCheckedInToday, isFalse);

        final initialQuests = await quests.getQuestsForDate(
          dateStr,
          type: 'daily',
        );
        final checkinQuestInitial = initialQuests.firstWhere(
          (q) => q.questId == kCheckinQuestId,
        );
        expect(checkinQuestInitial.completed, 0);

        // 2. Render CheckinScreen and submit via UI
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<UserProvider>.value(value: userProvider),
                ChangeNotifierProvider<CheckinProvider>.value(
                  value: checkinProvider,
                ),
                ChangeNotifierProvider<QuestProvider>.value(
                  value: questProvider,
                ),
              ],
              child: CheckinScreen(provider: checkinProvider),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Select mood: Tenang (mood 4)
        await tester.tap(find.text('Tenang'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Select trigger: Stres
        await tester.tap(find.text('Stres'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap submit
        await tester.tap(find.text('Simpan Check-in'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        // 3. Verify SQLite and Provider State
        expect(checkinProvider.hasCheckedInToday, isTrue);
        expect(checkinProvider.currentStreak, 1);

        final saved = await checkins.getByDate(now);
        expect(saved, isNotNull);
        expect(saved!.status, 'clean');
        expect(saved.mood, 4);
        expect(saved.xpEarned, 20);

        // Check-in quest should be marked completed
        final activeQuestsAfter = await quests.getQuestsForDate(
          dateStr,
          type: 'daily',
        );
        final checkinQuestAfter = activeQuestsAfter.firstWhere(
          (q) => q.questId == kCheckinQuestId,
        );
        expect(checkinQuestAfter.completed, 1);

        // User XP: 20 XP from clean check-in + 25 XP from completing check-in quest = 45 XP
        await userProvider.loadProfile();
        expect(userProvider.totalXp, 45);

        // Streak table or user profile updated
        expect(userProvider.currentStreak, 1);
      },
    );

    testWidgets(
      'Flow 2: Meditation session completion -> XP awarded & stats updated',
      (tester) async {
        final now = DateTime(2026, 9, 27, 14, 0);

        final userProvider = UserProvider(users, xp);
        await userProvider.loadProfile();
        final initialXp = userProvider.totalXp;

        final meditationProvider = MeditationProvider(
          meditation,
          xp,
          quests: questService,
          achievements: achievementService,
        );
        await meditationProvider.loadStats();

        expect(meditationProvider.totalMinutes, 0);
        expect(meditationProvider.sessionCount, 0);

        // Complete 10 minutes session (durationSeconds = 600)
        final award = await meditationProvider.completeSession(
          durationSeconds: 600,
          audioType: 'rain',
          breathingType: 'box',
          now: now,
        );

        // Spec §3.1: 10 minutes meditation earns 15 XP
        expect(award.amount, 15);
        expect(meditationProvider.totalMinutes, 10);
        expect(meditationProvider.sessionCount, 1);

        // Verify in SQLite
        final totalSeconds = await meditation.totalCompletedSeconds();
        expect(totalSeconds, 600);
        final completedCount = await meditation.completedCount();
        expect(completedCount, 1);

        final history = await meditation.getHistory();
        expect(history.length, 1);
        expect(history.first.durationSeconds, 600);
        expect(history.first.audioType, 'rain');
        expect(history.first.breathingType, 'box');
        expect(history.first.completed, 1);

        // Verify XP on user profile
        await userProvider.loadProfile();
        expect(userProvider.totalXp, initialXp + 15);
      },
    );

    testWidgets(
      'Flow 3: Bodyweight workout completion -> XP awarded & workout session recorded',
      (tester) async {
        final now = DateTime(2026, 9, 27, 16, 0);

        final userProvider = UserProvider(users, xp);
        await userProvider.loadProfile();
        final initialXp = userProvider.totalXp;

        final workoutProvider = WorkoutProvider(
          workouts,
          xp,
          quests: questService,
          achievements: achievementService,
        );
        await workoutProvider.loadStats();

        expect(workoutProvider.sessionCount, 0);

        // Complete Morning Energy routine (15 min duration)
        final routine = findRoutineById('morning_energy')!;
        final award = await workoutProvider.completeWorkout(
          routineId: routine.id,
          routineName: routine.name,
          durationSeconds: 900,
          exercisesCompleted: routine.exerciseIds.length,
          exercisesTotal: routine.exerciseIds.length,
          now: now,
        );

        // Spec §3.1: 15 min workout routine earns 25 XP
        expect(award.amount, 25);
        expect(workoutProvider.sessionCount, 1);

        // Verify in SQLite
        final count = await workouts.completedCount();
        expect(count, 1);

        final history = await workouts.getHistory();
        expect(history.length, 1);
        expect(history.first.routineId, 'morning_energy');
        expect(history.first.routineName, 'Morning Energy');
        expect(history.first.durationSeconds, 900);

        // Verify XP on user profile
        await userProvider.loadProfile();
        expect(userProvider.totalXp, initialXp + 25);
      },
    );

    testWidgets(
      'Flow 4: Level-up trigger -> Brain stage progression (Dormant -> Awakening)',
      (tester) async {
        // Level 5 threshold is 606 XP (Stage: dormant, levels 1-5)
        // Level 6 threshold is 906 XP (Stage: awakening, levels 6-15)
        // Ensure user profile singleton row exists
        await users.getOrCreateProfile();
        await users.updateProfile(
          const UserProfile(
            id: 1,
            level: 5,
            totalXp: 900,
            currentStreak: 0,
            longestStreak: 0,
            brainStage: 'dormant',
          ),
        );

        final userProvider = UserProvider(users, xp);
        await userProvider.loadProfile();

        expect(userProvider.level, 5);
        expect(userProvider.brainStage, 'dormant');
        expect(userProvider.totalXp, 900);

        // Award 20 XP, reaching 920 XP and passing the Level 6 threshold (906 XP)
        final award = await userProvider.awardXp(20);

        expect(award.leveledUp, isTrue);
        expect(award.levelBefore, 5);
        expect(award.levelAfter, 6);
        expect(userProvider.level, 6);
        expect(userProvider.brainStage, 'awakening');
        expect(userProvider.totalXp, 920);

        // Verify SQLite database persistence
        final profile = await users.getProfile();
        expect(profile!.level, 6);
        expect(profile.brainStage, 'awakening');
        expect(profile.totalXp, 920);

        // Verify UI renders evolved stage
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<UserProvider>.value(
                value: userProvider,
                child: BrainVisual(provider: userProvider),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('Level 6'), findsOneWidget);
        expect(find.text('AWAKENING'), findsOneWidget);
      },
    );
  });
}
