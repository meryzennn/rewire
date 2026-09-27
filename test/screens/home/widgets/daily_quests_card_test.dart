import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/screens/home/widgets/daily_quests_card.dart';

void main() {
  testWidgets('renders daily quests with completed and active styling', (
    tester,
  ) async {
    final quests = [
      const Quest(
        id: 1,
        questId: 'meditate_10min',
        type: 'daily',
        title: 'Meditasi Pagi 10 Menit',
        xpReward: 50,
        targetValue: 10,
        currentValue: 10,
        completed: 1,
        dateAssigned: '2026-09-27',
      ),
      const Quest(
        id: 2,
        questId: 'workout_light',
        type: 'daily',
        title: 'Jalan Kaki & Olahraga Ringan',
        xpReward: 40,
        targetValue: 1,
        currentValue: 1,
        completed: 1,
        dateAssigned: '2026-09-27',
      ),
      const Quest(
        id: 3,
        questId: 'gratitude_journal',
        type: 'daily',
        title: 'Tulis 3 Rasa Syukur (Journal)',
        xpReward: 30,
        targetValue: 1,
        currentValue: 0,
        completed: 0,
        dateAssigned: '2026-09-27',
      ),
      const Quest(
        id: 4,
        questId: 'review_mindset',
        type: 'daily',
        title: 'Review Mindset Sebelum Tidur',
        xpReward: 40,
        targetValue: 1,
        currentValue: 0,
        completed: 0,
        dateAssigned: '2026-09-27',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DailyQuestsCard(quests: quests)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Daily Quests'), findsOneWidget);
    expect(find.text('2/4 ✓'), findsOneWidget);

    expect(find.text('Meditasi Pagi 10 Menit'), findsOneWidget);
    expect(find.text('Jalan Kaki & Olahraga Ringan'), findsOneWidget);
    expect(find.text('Tulis 3 Rasa Syukur (Journal)'), findsOneWidget);
    expect(find.text('Review Mindset Sebelum Tidur'), findsOneWidget);

    // XP chips
    expect(find.text('+50 XP'), findsOneWidget);
    expect(find.text('+40 XP'), findsNWidgets(2));
    expect(find.text('+30 XP'), findsOneWidget);

    // Two checkmarks for completed quests
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });
}
