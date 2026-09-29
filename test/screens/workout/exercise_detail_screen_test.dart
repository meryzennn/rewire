import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/screens/workout/exercise_detail_screen.dart';
import 'package:rewire/screens/workout/widgets/exercise_illustration_slider.dart';

void main() {
  testWidgets('renders all exercise detail components', (tester) async {
    final exercise = kAllExercises.first; // Push-up

    await tester.pumpWidget(
      MaterialApp(home: ExerciseDetailScreen(exercise: exercise)),
    );

    // Headline and App bar
    expect(find.text('Push-up'), findsNWidgets(2)); // in AppBar and Headline

    // Illustration renders ExerciseIllustrationSlider and no barbell icon
    expect(find.byType(ExerciseIllustrationSlider), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsNothing);

    // Category and difficulty badges
    expect(find.text('Upper'), findsWidgets);
    expect(find.text('Beginner'), findsOneWidget);

    // Target sets and reps
    expect(find.text('3 Set'), findsOneWidget);
    expect(find.text('12 Repetisi'), findsOneWidget);

    // Muscles and instructions
    expect(find.text('Dada & Trisep'), findsOneWidget);
    expect(find.text('Instruksi'), findsOneWidget);
    expect(find.text(exercise.description), findsOneWidget);

    // Tips card
    expect(find.text('Tips Pemulihan & Postur'), findsOneWidget);

    // Start button
    expect(
      find.byKey(const Key('exercise-detail-start-button')),
      findsOneWidget,
    );
    expect(find.text('Mulai Latihan Ini'), findsOneWidget);
  });
}
