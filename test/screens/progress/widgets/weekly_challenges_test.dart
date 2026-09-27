import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/screens/progress/widgets/weekly_challenges.dart';

void main() {
  testWidgets('renders empty placeholder when no weekly challenges exist',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeeklyChallenges(challenges: []),
        ),
      ),
    );

    expect(find.text('Tantangan Mingguan'), findsOneWidget);
    expect(find.text('Tidak ada tantangan mingguan aktif'), findsOneWidget);
  });

  testWidgets('renders list of active weekly challenges with progress bars',
      (tester) async {
    final challenges = [
      Quest(
        id: 1,
        questId: 'weekly_meditate_5days',
        type: 'weekly',
        title: 'Meditasi 5 hari minggu ini',
        description: 'Lakukan meditasi di 5 hari berbeda',
        xpReward: 100,
        targetValue: 5,
        currentValue: 3,
        completed: 0,
        dateAssigned: '2026-09-21',
      ),
      Quest(
        id: 2,
        questId: 'weekly_workout_3',
        type: 'weekly',
        title: '3 workout minggu ini',
        description: 'Selesaikan 3 sesi latihan fisik',
        xpReward: 100,
        targetValue: 3,
        currentValue: 3,
        completed: 1,
        dateAssigned: '2026-09-21',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeeklyChallenges(challenges: challenges),
        ),
      ),
    );

    expect(find.text('Tantangan Mingguan'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget); // 1 of 2 completed
    expect(find.text('Meditasi 5 hari minggu ini'), findsOneWidget);
    expect(find.text('3/5'), findsOneWidget);
    expect(find.text('3 workout minggu ini'), findsOneWidget);
    expect(find.text('3/3'), findsOneWidget);
    expect(find.text('+100 XP'), findsNWidgets(2));
  });
}
