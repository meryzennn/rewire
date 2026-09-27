import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/achievement.dart';
import 'package:rewire/screens/progress/widgets/achievement_grid.dart';

void main() {
  testWidgets('renders empty placeholder when achievements list is empty',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AchievementGrid(achievements: []),
        ),
      ),
    );

    expect(find.text('Pencapaian'), findsOneWidget);
    expect(find.text('Belum ada data pencapaian'), findsOneWidget);
  });

  testWidgets('renders unlocked and locked achievements correctly',
      (tester) async {
    final achievements = [
      const Achievement(
        badgeId: 'first_spark',
        title: 'First Spark',
        description: '1 day clean',
        icon: '🔥',
        unlocked: 1,
        dateUnlocked: '2026-09-27',
      ),
      const Achievement(
        badgeId: 'week_warrior',
        title: 'Week Warrior',
        description: '7-day streak',
        icon: '⚡',
        unlocked: 0,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementGrid(achievements: achievements),
        ),
      ),
    );

    expect(find.text('Pencapaian'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget); // 1 unlocked out of 2
    expect(find.text('First Spark'), findsOneWidget);
    expect(find.text('Week Warrior'), findsOneWidget);

    // Unlocked icon vs locked icon
    expect(find.text('🔥'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    // Tap achievement to see detail dialog
    await tester.tap(find.text('First Spark'));
    await tester.pumpAndSettle();

    expect(find.text('1 day clean'), findsOneWidget);
    expect(find.textContaining('Terbuka'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.text('1 day clean'), findsNothing);
  });
}
