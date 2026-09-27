import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/meditation/meditation_complete_screen.dart';
import 'package:rewire/services/xp_service.dart';

Widget buildCompleteScreen({
  required int durationMinutes,
  required XpAward award,
}) {
  return MaterialApp(
    home: MeditationCompleteScreen(
      durationMinutes: durationMinutes,
      xpAward: award,
    ),
  );
}

void main() {
  testWidgets('renders completion headline, duration, and XP reward',
      (tester) async {
    const award = XpAward(
      amount: 20,
      totalXpBefore: 30,
      totalXpAfter: 50,
      levelBefore: 1,
      levelAfter: 2,
    );

    await tester.pumpWidget(buildCompleteScreen(
      durationMinutes: 15,
      award: award,
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sesi Selesai! 🧘'), findsOneWidget);
    expect(find.text('15 menit meditasi terlewati'), findsOneWidget);
    expect(find.text('+20 XP'), findsOneWidget);

    // Level up message
    expect(find.text('Level Up! Kamu mencapai Level 2'), findsOneWidget);

    // Selesai button
    expect(find.text('Selesai'), findsOneWidget);
  });

  testWidgets('does not show level up banner when no level up occurs',
      (tester) async {
    const award = XpAward(
      amount: 15,
      totalXpBefore: 10,
      totalXpAfter: 25,
      levelBefore: 1,
      levelAfter: 1,
    );

    await tester.pumpWidget(buildCompleteScreen(
      durationMinutes: 10,
      award: award,
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('+15 XP'), findsOneWidget);
    expect(find.textContaining('Level Up'), findsNothing);
  });
}
