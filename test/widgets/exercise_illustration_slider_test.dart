import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/screens/workout/widgets/exercise_illustration_slider.dart';

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

  group('ExerciseIllustrationSlider', () {
    testWidgets('renders PageView for pushup and can be swiped left and right', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 250,
              child: ExerciseIllustrationSlider(exercise: pushup),
            ),
          ),
        ),
      );

      // Barbell icon must NOT be present
      expect(find.byIcon(Icons.fitness_center), findsNothing);

      // PageView should be present
      expect(find.byType(PageView), findsOneWidget);

      // First frame pushup-1.png should be rendered initially
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/exercises/pushup/pushup-1.png',
        ),
        findsOneWidget,
      );

      // Drag/swipe to the left to show the next frame
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      // Now pushup-2.png should be visible
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/exercises/pushup/pushup-2.png',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders static image without PageView for single-frame exercise', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 250,
              child: ExerciseIllustrationSlider(exercise: staticExercise),
            ),
          ),
        ),
      );

      // No PageView for static exercises
      expect(find.byType(PageView), findsNothing);

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
  });
}
