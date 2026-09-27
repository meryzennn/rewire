import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/progress/widgets/stat_cards_grid.dart';

void main() {
  testWidgets('renders all 6 recovery stat cards accurately', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: StatCardsGrid(
              currentStreak: 15,
              longestStreak: 23,
              cleanDays: 45,
              meditationMinutes: 320,
              workoutSessions: 28,
              totalXp: 12450,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Statistik Pikiran'), findsOneWidget);
    expect(find.text('Streak Saat Ini'), findsOneWidget);
    expect(find.text('15 Hari'), findsOneWidget);

    expect(find.text('Streak Terpanjang'), findsOneWidget);
    expect(find.text('23 Hari'), findsOneWidget);

    expect(find.text('Total Hari Clean'), findsOneWidget);
    expect(find.text('45 Hari'), findsOneWidget);

    expect(find.text('Total Meditasi'), findsOneWidget);
    expect(find.text('320 Menit'), findsOneWidget);

    expect(find.text('Total Workout'), findsOneWidget);
    expect(find.text('28 Sesi'), findsOneWidget);

    expect(find.text('Total Akumulasi'), findsOneWidget);
    expect(find.text('12450 XP'), findsOneWidget);
  });
}
