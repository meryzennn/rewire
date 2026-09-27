import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/routines.dart';
import 'package:rewire/screens/workout/workout_complete_screen.dart';
import 'package:rewire/services/xp_service.dart';

void main() {
  testWidgets('renders all workout completion components without level up',
      (tester) async {
    final routine = kAllRoutines.first; // Morning Energy (15 min)

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutCompleteScreen(
          routine: routine,
          durationSeconds: 900,
          exercisesCompleted: 6,
          exercisesTotal: 6,
          xpAward: const XpAward(
            amount: 25,
            totalXpBefore: 100,
            totalXpAfter: 125,
            levelBefore: 3,
            levelAfter: 3,
          ),
        ),
      ),
    );

    expect(find.text('Workout Selesai! 💪'), findsOneWidget);
    expect(find.text('Morning Energy'), findsOneWidget);
    expect(find.text('15 menit · 6 gerakan selesai'), findsOneWidget);
    expect(find.text('+25 XP'), findsOneWidget);
    expect(find.byKey(const Key('workout-complete-done-button')), findsOneWidget);
    expect(find.textContaining('Level Up!'), findsNothing);
  });

  testWidgets('renders level up callout when didLevelUp is true', (tester) async {
    final routine = kAllRoutines[1]; // Full Body Burn (20 min)

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutCompleteScreen(
          routine: routine,
          durationSeconds: 1200,
          exercisesCompleted: 8,
          exercisesTotal: 8,
          xpAward: const XpAward(
            amount: 30,
            totalXpBefore: 600,
            totalXpAfter: 630,
            levelBefore: 5,
            levelAfter: 6,
          ),
        ),
      ),
    );

    expect(find.text('Workout Selesai! 💪'), findsOneWidget);
    expect(find.text('Full Body Burn'), findsOneWidget);
    expect(find.text('20 menit · 8 gerakan selesai'), findsOneWidget);
    expect(find.text('+30 XP'), findsOneWidget);
    expect(find.text('Level Up! Kamu mencapai Level 6'), findsOneWidget);
  });
}
