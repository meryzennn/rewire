import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/screens/progress/widgets/mood_trend_chart.dart';

void main() {
  testWidgets('renders empty placeholder when no mood data exists',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MoodTrendChart(checkins: []),
        ),
      ),
    );

    expect(find.text('Tren Suasana Hati'), findsOneWidget);
    expect(
      find.text('Belum ada catatan suasana hati 7 hari terakhir'),
      findsOneWidget,
    );
    expect(find.byType(LineChart), findsNothing);
  });

  testWidgets('renders LineChart when mood entries exist', (tester) async {
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
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodTrendChart(
            checkins: checkins,
            now: now,
          ),
        ),
      ),
    );

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('Tren Suasana Hati'), findsOneWidget);
  });
}
