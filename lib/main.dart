import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/database/database_helper.dart';
import 'providers/achievement_provider.dart';
import 'providers/checkin_provider.dart';
import 'providers/meditation_provider.dart';
import 'providers/quest_provider.dart';
import 'providers/user_provider.dart';
import 'providers/workout_provider.dart';
import 'repositories/achievement_repository.dart';
import 'repositories/checkin_repository.dart';
import 'repositories/meditation_repository.dart';
import 'repositories/quest_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/workout_repository.dart';
import 'services/achievement_service.dart';
import 'services/preference_service.dart';
import 'services/quest_service.dart';
import 'services/xp_service.dart';

Future<void> main() async {
  // The DB open and SharedPreferences load are both async, so init must run
  // before the first frame.
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper.instance.database;
  final prefs = await SharedPreferences.getInstance();
  final preferences = PreferenceService(prefs);

  // One shared Database backs every repository (spec §2.4).
  final users = UserRepository(db);
  final checkins = CheckinRepository(db);
  final meditation = MeditationRepository(db);
  final workouts = WorkoutRepository(db);
  final quests = QuestRepository(db);
  final achievements = AchievementRepository(db);

  final xp = XpService(users, checkins);
  final questService = QuestService(quests, xp);
  final achievementService = AchievementService(
    users,
    checkins,
    meditation,
    workouts,
    quests,
    achievements,
  );

  final router = buildRouter(
    prefs,
    preferences: preferences,
    onResetData: () => DatabaseHelper.instance.resetData(),
  );

  // Root providers (spec §2.2). Kept at the app root so Task 13 can preserve
  // them across the widget it wraps.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(users, xp)..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => CheckinProvider(
            checkins,
            xp,
            users: users,
            quests: questService,
            achievements: achievementService,
          )..loadToday(),
        ),
        ChangeNotifierProvider(
          create: (_) => MeditationProvider(meditation, xp),
        ),
        ChangeNotifierProvider(create: (_) => WorkoutProvider(workouts, xp)),
        ChangeNotifierProvider(
          create: (_) => QuestProvider(questService)..loadDailyQuests(),
        ),
        ChangeNotifierProvider(
          create: (_) => AchievementProvider(achievementService),
        ),
      ],
      child: RewireApp(router: router, preferences: preferences),
    ),
  );
}
