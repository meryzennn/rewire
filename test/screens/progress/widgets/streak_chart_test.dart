import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/screens/progress/widgets/streak_chart.dart';

void main() {
  testWidgets('renders streak chart with empty history without errors',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StreakChart(checkins: []),
        ),
      ),
    );

    expect(find.text('Streak History'), findsOneWidget);
    expect(find.text('7 Hari Terakhir'), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.text('Clean Day'), findsOneWidget);
    expect(find.text('Relapse Day'), findsOneWidget);
  });

  testWidgets('renders streak chart with populated checkin history',
      (tester) async {
    final now = DateTime(2026, 9, 27);
    final checkins = [
      DailyCheckin(
        date: '2026-09-27',
        status: 'clean',
        mood: 4,
        xpEarned: 20,
      ),
      DailyCheckin(
        date: '2026-09-26',
        status: 'clean',
        mood: 5,
        xpEarned: 20,
      ),
      DailyCheckin(
        date: '2026-09-25',
        status: 'relapse',
        mood: 2,
        xpEarned: 0,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreakChart(
            checkins: checkins,
            now: now,
          ),
        ),
      ),
    );

    expect(find.byType(BarChart), findsOneWidget);
  });
}
