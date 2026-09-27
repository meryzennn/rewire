import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/workout/rest_timer_screen.dart';

void main() {
  testWidgets('renders rest timer and invokes onRestComplete when skip is tapped',
      (tester) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: RestTimerScreen(
          durationSeconds: 30,
          nextExerciseName: 'Plank',
          nextExerciseSetsReps: '3 × 30 detik',
          onRestComplete: () {
            completed = true;
          },
        ),
      ),
    );

    expect(find.text('Istirahat'), findsOneWidget);
    expect(find.text('Next: Plank'), findsOneWidget);
    expect(find.text('3 × 30 detik'), findsOneWidget);
    expect(find.byKey(const Key('skip-rest-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('skip-rest-button')));
    await tester.pump();

    expect(completed, isTrue);
  });
}
