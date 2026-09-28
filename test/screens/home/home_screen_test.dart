import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/providers/checkin_provider.dart';
import 'package:rewire/providers/quest_provider.dart';
import 'package:rewire/providers/user_provider.dart';
import 'package:rewire/screens/home/home_screen.dart';
import 'package:rewire/screens/home/widgets/brain_visual.dart';
import 'package:rewire/screens/home/widgets/daily_quests_card.dart';
import 'package:rewire/screens/home/widgets/quick_actions.dart';
import 'package:rewire/screens/home/widgets/streak_card.dart';
import 'package:rewire/widgets/level_up_dialog.dart';

class FakeUserProvider extends ChangeNotifier implements UserProvider {
  FakeUserProvider({
    this.level = 1,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.brainStage = 'dormant',
    this.levelProgress = 0.0,
    this.xpInLevel = 0,
    this.xpSpan = 50,
  });

  @override
  int level;
  @override
  int totalXp;
  @override
  int currentStreak;
  @override
  int longestStreak;
  @override
  String brainStage;
  @override
  double levelProgress;
  @override
  int xpInLevel;
  @override
  int xpSpan;

  @override
  bool isLoading = false;

  void triggerLevelUp(int newLevel, String newStage) {
    level = newLevel;
    brainStage = newStage;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCheckinProvider extends ChangeNotifier implements CheckinProvider {
  FakeCheckinProvider({
    this.currentStreak = 7,
    this.longestStreak = 10,
    this.todayCheckin,
    this.todayTriggers = const [],
  });

  @override
  int currentStreak;
  @override
  int longestStreak;
  @override
  DailyCheckin? todayCheckin;
  @override
  List<String> todayTriggers;
  @override
  bool isLoading = false;

  @override
  bool get hasCheckedInToday => todayCheckin != null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeQuestProvider extends ChangeNotifier implements QuestProvider {
  FakeQuestProvider({this.dailyQuests = const []});

  @override
  List<Quest> dailyQuests;

  @override
  bool isLoading = false;

  @override
  int get completedDailyCount =>
      dailyQuests.where((q) => q.completed == 1).length;

  @override
  int get totalDailyCount => dailyQuests.length;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildHomeScreen({
    required FakeUserProvider userProvider,
    required FakeCheckinProvider checkinProvider,
    required FakeQuestProvider questProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider<CheckinProvider>.value(value: checkinProvider),
        ChangeNotifierProvider<QuestProvider>.value(value: questProvider),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('renders all Stitch Home Screen components', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final userProvider = FakeUserProvider(
      level: 12,
      brainStage: 'awakening',
      totalXp: 720,
      currentStreak: 14,
      longestStreak: 21,
    );
    final checkinProvider = FakeCheckinProvider(
      currentStreak: 14,
      longestStreak: 21,
    );
    final questProvider = FakeQuestProvider(
      dailyQuests: [
        const Quest(
          id: 1,
          questId: 'meditate_10min',
          type: 'daily',
          title: 'Meditasi Pagi 10 Menit',
          xpReward: 50,
          targetValue: 10,
          currentValue: 10,
          completed: 1,
          dateAssigned: '2026-09-27',
        ),
      ],
    );

    await tester.pumpWidget(
      buildHomeScreen(
        userProvider: userProvider,
        checkinProvider: checkinProvider,
        questProvider: questProvider,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Brand and top bar
    expect(find.text('Rewire'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsNothing);

    // Section 1: Brain Visual
    expect(find.byType(BrainVisual), findsOneWidget);
    expect(find.text('Level 12'), findsOneWidget);
    expect(find.text('AWAKENING'), findsOneWidget);

    // Section 2: Streak Card
    expect(find.byType(StreakCard), findsOneWidget);
    expect(find.text('14 Hari'), findsOneWidget);

    // Section 3: Daily Quests Card
    expect(find.byType(DailyQuestsCard), findsOneWidget);
    expect(find.text('Daily Quests'), findsOneWidget);

    // Section 4: Quick Actions
    expect(find.byType(QuickActions), findsOneWidget);
    expect(find.text('Aksi Pemulihan'), findsOneWidget);
  });

  testWidgets('detects level up event and shows LevelUpDialog', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final userProvider = FakeUserProvider(level: 1, brainStage: 'dormant');
    final checkinProvider = FakeCheckinProvider();
    final questProvider = FakeQuestProvider();

    await tester.pumpWidget(
      buildHomeScreen(
        userProvider: userProvider,
        checkinProvider: checkinProvider,
        questProvider: questProvider,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LevelUpDialog), findsNothing);

    // Trigger level up
    userProvider.triggerLevelUp(2, 'dormant');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LevelUpDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LevelUpDialog),
        matching: find.text('Level 2'),
      ),
      findsOneWidget,
    );
  });
}
