import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/screens/workout/widgets/animated_exercise_illustration.dart';

void main() {
  final pushup = kAllExercises.firstWhere((e) => e.id == 'pushup');
  const staticExercise = Exercise(
    id: 'static_exercise',
    name: 'Static Exercise',
    category: 'Upper',
    defaultSets: 3,
    defaultReps: 10,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Static description',
    targetMuscles: 'Full Body',
    imageAssetPath: 'assets/images/exercises/pushup.png',
  );

  group('AnimatedExerciseIllustration', () {
    testWidgets('renders first frame for pushup and contains no barbell icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExerciseIllustration(exercise: pushup),
          ),
        ),
      );

      // Barbell icon must NOT be present
      expect(find.byIcon(Icons.fitness_center), findsNothing);

      // First frame pushup-1.png should be rendered
      final firstFrame = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/exercises/pushup/pushup-1.png',
      );
      expect(firstFrame, findsOneWidget);
    });

    testWidgets('cycles through pushup frames over time with fade transition', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExerciseIllustration(
              exercise: pushup,
              autoPlay: true,
              frameDuration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      );

      // Initially frame 1
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName ==
                  'assets/images/exercises/pushup/pushup-1.png',
        ),
        findsOneWidget,
      );

      // Advance by 500ms + fade
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));

      // Now frame 2 is rendered
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName ==
                  'assets/images/exercises/pushup/pushup-2.png',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders static image for exercise without animation frames', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExerciseIllustration(exercise: staticExercise),
          ),
        ),
      );

      // Static image is rendered
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName == staticExercise.imageAssetPath,
        ),
        findsOneWidget,
      );

      // No barbell icon
      expect(find.byIcon(Icons.fitness_center), findsNothing);
    });

    testWidgets('renders first frame for knee_pushup and cycles with fade', (
      tester,
    ) async {
      final kneePushup =
          kAllExercises.firstWhere((e) => e.id == 'knee_pushup');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExerciseIllustration(
              exercise: kneePushup,
              autoPlay: true,
              frameDuration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      );

      // Barbell icon must NOT be present
      expect(find.byIcon(Icons.fitness_center), findsNothing);

      // First frame knee-pushup_1.png
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName ==
                  'assets/images/exercises/knee-pushup/knee-pushup_1.png',
        ),
        findsOneWidget,
      );

      // Advance by 500ms + fade
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));

      // Now frame 2 is rendered
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName ==
                  'assets/images/exercises/knee-pushup/knee-pushup_2.png',
        ),
        findsOneWidget,
      );
    });
  });
}
