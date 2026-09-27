import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/home/widgets/quick_actions.dart';

void main() {
  testWidgets('renders all three recovery quick actions and responds to taps', (tester) async {
    var medTapped = false;
    var workTapped = false;
    var statsTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuickActions(
            onMeditationTap: () => medTapped = true,
            onWorkoutTap: () => workTapped = true,
            onStatsTap: () => statsTapped = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aksi Pemulihan'), findsOneWidget);
    expect(find.text('Meditasi'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);

    await tester.tap(find.text('Meditasi'));
    await tester.pumpAndSettle();
    expect(medTapped, isTrue);

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();
    expect(workTapped, isTrue);

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(statsTapped, isTrue);
  });
}
