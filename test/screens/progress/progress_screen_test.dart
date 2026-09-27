import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/models/achievement.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/providers/achievement_provider.dart';
import 'package:rewire/providers/quest_provider.dart';
import 'package:rewire/providers/user_provider.dart';
import 'package:rewire/screens/progress/progress_screen.dart';

class FakeUserProvider extends ChangeNotifier implements UserProvider {
  FakeUserProvider({UserProfile? profile})
      : _profile = profile ??
            const UserProfile(
              level: 12,
              totalXp: 3500,
              currentStreak: 10,
              longestStreak: 15,
              brainStage: 'awakening',
            );

  UserProfile? _profile;

  @override
  UserProfile? get profile => _profile;

  @override
  bool isLoading = false;

  @override
  Future<void> loadProfile() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeQuestProvider extends ChangeNotifier implements QuestProvider {
  FakeQuestProvider({List<Quest>? weeklyQuests})
      : _weeklyQuests = weeklyQuests ?? const [];

  List<Quest> _weeklyQuests;

  @override
  List<Quest> get weeklyQuests => _weeklyQuests;

  @override
  List<Quest> get dailyQuests => const [];

  @override
  bool isLoading = false;

  @override
  Future<void> loadAllQuests({DateTime? now}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAchievementProvider extends ChangeNotifier
    implements AchievementProvider {
  FakeAchievementProvider({List<Achievement>? items})
      : _items = items ?? const [];

  List<Achievement> _items;

  @override
  List<Achievement> get items => _items;

  @override
  bool isLoading = false;

  @override
  Future<void> loadAchievements({DateTime? now}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget buildScreen({
  required FakeUserProvider userProvider,
  required FakeQuestProvider questProvider,
  required FakeAchievementProvider achievementProvider,
  List<DailyCheckin>? checkins,
  int? cleanDays,
  int? meditationMinutes,
  int? workoutSessions,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>.value(value: userProvider),
      ChangeNotifierProvider<QuestProvider>.value(value: questProvider),
      ChangeNotifierProvider<AchievementProvider>.value(
        value: achievementProvider,
      ),
    ],
    child: MaterialApp(
      home: ProgressScreen(
        userProvider: userProvider,
        questProvider: questProvider,
        achievementProvider: achievementProvider,
        initialCheckins: checkins,
        initialCleanDays: cleanDays,
        initialMeditationMinutes: meditationMinutes,
        initialWorkoutSessions: workoutSessions,
      ),
    ),
  );
}

void main() {
  void setViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('renders progress screen with empty history without errors',
      (tester) async {
    setViewport(tester);

    final userProvider = FakeUserProvider(
      profile: const UserProfile(
        level: 1,
        totalXp: 0,
        currentStreak: 0,
        longestStreak: 0,
        brainStage: 'dormant',
      ),
    );
    final questProvider = FakeQuestProvider(weeklyQuests: []);
    final achievementProvider = FakeAchievementProvider(items: []);

    await tester.pumpWidget(
      buildScreen(
        userProvider: userProvider,
        questProvider: questProvider,
        achievementProvider: achievementProvider,
        checkins: [],
        cleanDays: 0,
        meditationMinutes: 0,
        workoutSessions: 0,
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top bar
    expect(find.text('Progress'), findsOneWidget);

    // 2. Brain hero card
    expect(find.text('Level 1'), findsOneWidget);
    expect(find.text('Dormant 🌑'), findsOneWidget);

    // 3. Stats grid
    expect(find.text('0 Hari'), findsNWidgets(3)); // current, longest, clean
    expect(find.text('0 Menit'), findsOneWidget); // meditation
    expect(find.text('0 Sesi'), findsOneWidget); // workout
    expect(find.text('0 XP'), findsOneWidget); // total XP

    // 4. Streak History & Mood Charts
    expect(find.text('Streak History'), findsOneWidget);
    expect(find.text('Tren Suasana Hati'), findsOneWidget);

    // 5. Weekly Challenges & Achievements
    expect(find.text('Tantangan Mingguan'), findsOneWidget);
    expect(find.text('Pencapaian'), findsOneWidget);
  });

  testWidgets('renders progress screen with populated data and achievements',
      (tester) async {
    setViewport(tester);

    final userProvider = FakeUserProvider(
      profile: const UserProfile(
        level: 15,
        totalXp: 5781,
        currentStreak: 12,
        longestStreak: 20,
        brainStage: 'awakening',
      ),
    );

    final weeklyQuests = [
      Quest(
        id: 1,
        questId: 'weekly_meditate_5days',
        type: 'weekly',
        title: 'Meditasi 5 hari minggu ini',
        description: 'Lakukan meditasi di 5 hari berbeda',
        xpReward: 100,
        targetValue: 5,
        currentValue: 3,
        completed: 0,
        dateAssigned: '2026-09-21',
      ),
    ];

    final achievements = [
      const Achievement(
        badgeId: 'first_spark',
        title: 'First Spark',
        description: '1 day clean',
        icon: '🔥',
        unlocked: 1,
        dateUnlocked: '2026-09-20',
      ),
      const Achievement(
        badgeId: 'week_warrior',
        title: 'Week Warrior',
        description: '7-day streak',
        icon: '⚡',
        unlocked: 1,
        dateUnlocked: '2026-09-27',
      ),
    ];

    final checkins = [
      DailyCheckin(
        date: '2026-09-27',
        status: 'clean',
        mood: 5,
        xpEarned: 20,
      ),
      DailyCheckin(
        date: '2026-09-26',
        status: 'clean',
        mood: 4,
        xpEarned: 20,
      ),
    ];

    final questProvider = FakeQuestProvider(weeklyQuests: weeklyQuests);
    final achievementProvider = FakeAchievementProvider(items: achievements);

    await tester.pumpWidget(
      buildScreen(
        userProvider: userProvider,
        questProvider: questProvider,
        achievementProvider: achievementProvider,
        checkins: checkins,
        cleanDays: 12,
        meditationMinutes: 150,
        workoutSessions: 10,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Level 15'), findsOneWidget);
    expect(find.text('Awakening 🌱'), findsOneWidget);

    expect(find.text('12 Hari'), findsNWidgets(2)); // current streak and clean days
    expect(find.text('20 Hari'), findsOneWidget); // longest streak
    expect(find.text('150 Menit'), findsOneWidget);
    expect(find.text('10 Sesi'), findsOneWidget);
    expect(find.text('5781 XP'), findsOneWidget);

    expect(find.text('Meditasi 5 hari minggu ini'), findsOneWidget);
    expect(find.text('First Spark'), findsOneWidget);
    expect(find.text('Week Warrior'), findsOneWidget);
  });
}
