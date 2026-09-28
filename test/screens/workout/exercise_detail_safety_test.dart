import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/app.dart';
import 'package:rewire/core/theme/app_theme.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/l10n/app_localizations.dart';
import 'package:rewire/screens/workout/exercise_detail_screen.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PreferenceService> _createPrefService(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  return PreferenceService(prefs);
}

Widget _buildTestApp({
  required Exercise exercise,
  required PreferenceService prefService,
}) {
  final router = GoRouter(
    initialLocation: '/detail',
    routes: [
      GoRoute(
        path: '/detail',
        builder: (context, state) => ExerciseDetailScreen(
          exercise: exercise,
          preferences: prefService,
        ),
      ),
      GoRoute(
        path: Routes.activeWorkout,
        builder: (context, state) =>
            const Scaffold(body: Text('Active Workout Screen')),
      ),
      GoRoute(
        path: Routes.exerciseDetail,
        builder: (context, state) {
          final ex = state.extra as Exercise? ?? exercise;
          return ExerciseDetailScreen(
            exercise: ex,
            preferences: prefService,
          );
        },
      ),
    ],
  );

  return MaterialApp.router(
    theme: buildLightTheme(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}

void main() {
  final pushup = kAllExercises.firstWhere((e) => e.id == 'pushup');
  final jumpingJack = kAllExercises.firstWhere((e) => e.id == 'jumping_jack');
  final plank = kAllExercises.firstWhere((e) => e.id == 'plank');

  testWidgets(
    'displays joint safety caution banner and safe alternative for beginner',
    (tester) async {
      final prefs = await _createPrefService({
        'user_fitness_level': 'beginner',
        'user_height': 170.0,
        'user_weight': 65.0,
      });

      await tester.pumpWidget(
        _buildTestApp(exercise: pushup, prefService: prefs),
      );
      await tester.pumpAndSettle();

      // Caution banner should be visible
      expect(find.byKey(const Key('banner-joint-safety')), findsOneWidget);
      expect(find.textContaining('Joint Safety Caution'), findsOneWidget);

      // Safe alternative recommendation should be visible
      expect(find.byKey(const Key('btn-switch-alternative')), findsOneWidget);
      expect(find.textContaining('Knee Push-up'), findsOneWidget);

      // Tapping Start button opens safety confirmation dialog
      await tester.tap(find.byKey(const Key('exercise-detail-start-button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byKey(const Key('btn-use-safe-alternative')), findsOneWidget);
      expect(find.byKey(const Key('btn-proceed-anyway')), findsOneWidget);

      // Tapping Use Safe Alternative dismisses dialog
      await tester.tap(find.byKey(const Key('btn-use-safe-alternative')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'displays joint safety caution banner for user with BMI >= 30 (obese)',
    (tester) async {
      // Height 170cm, Weight 95kg -> BMI ~32.87 (Obese)
      final prefs = await _createPrefService({
        'user_fitness_level': 'intermediate',
        'user_height': 170.0,
        'user_weight': 95.0,
      });

      await tester.pumpWidget(
        _buildTestApp(exercise: jumpingJack, prefService: prefs),
      );
      await tester.pumpAndSettle();

      // Caution banner and alternative recommendation (Wall Sit)
      expect(find.byKey(const Key('banner-joint-safety')), findsOneWidget);
      expect(find.byKey(const Key('btn-switch-alternative')), findsOneWidget);
      expect(find.textContaining('Wall Sit'), findsOneWidget);

      // Tapping Start button opens safety confirmation dialog
      await tester.tap(find.byKey(const Key('exercise-detail-start-button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Tapping Proceed Anyway dismisses dialog
      await tester.tap(find.byKey(const Key('btn-proceed-anyway')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'does not display safety banner for intermediate user with normal BMI',
    (tester) async {
      final prefs = await _createPrefService({
        'user_fitness_level': 'intermediate',
        'user_height': 175.0,
        'user_weight': 70.0,
      });

      await tester.pumpWidget(
        _buildTestApp(exercise: pushup, prefService: prefs),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('banner-joint-safety')), findsNothing);
      expect(find.byKey(const Key('btn-switch-alternative')), findsNothing);

      // Tapping Start button does NOT show safety confirmation dialog
      await tester.tap(find.byKey(const Key('exercise-detail-start-button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'does not display safety banner for safe non-contraindicated exercise',
    (tester) async {
      final prefs = await _createPrefService({
        'user_fitness_level': 'beginner',
        'user_height': 170.0,
        'user_weight': 95.0,
      });

      await tester.pumpWidget(
        _buildTestApp(exercise: plank, prefService: prefs),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('banner-joint-safety')), findsNothing);
      expect(find.byKey(const Key('btn-switch-alternative')), findsNothing);
    },
  );
}
