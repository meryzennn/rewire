import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/progress/widgets/brain_timeline.dart';

void main() {
  testWidgets('renders brain timeline with level, stage, and XP progress',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BrainTimeline(
            level: 18,
            totalXp: 8500,
            brainStage: 'growing',
          ),
        ),
      ),
    );

    expect(find.text('Level 18'), findsOneWidget);
    expect(find.text('Growing 🌿'), findsOneWidget);
    expect(find.text('Pengalaman Jiwa'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // 5 Stages in timeline
    expect(find.text('Dormant'), findsOneWidget);
    expect(find.text('Awakening'), findsOneWidget);
    expect(find.text('Growing'), findsOneWidget);
    expect(find.text('Thriving'), findsOneWidget);
    expect(find.text('Transcendent'), findsOneWidget);
  });
}
