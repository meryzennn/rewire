import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/providers/checkin_provider.dart';
import 'package:rewire/screens/home/widgets/streak_card.dart';

class FakeCheckinProvider extends ChangeNotifier implements CheckinProvider {
  FakeCheckinProvider({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.todayCheckin,
    this.todayTriggers = const [],
  });

  @override
  int currentStreak;

  @override
  int longestStreak;

  @override
  DailyCheckin? todayCheckin;

  @override
  List<String> todayTriggers;

  @override
  bool isLoading = false;

  @override
  bool get hasCheckedInToday => todayCheckin != null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildCard(FakeCheckinProvider provider, {VoidCallback? onCheckinTap}) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<CheckinProvider>.value(
          value: provider,
          child: StreakCard(provider: provider, onCheckinTap: onCheckinTap),
        ),
      ),
    );
  }

  testWidgets('renders streak count and longest streak', (tester) async {
    final provider = FakeCheckinProvider(currentStreak: 14, longestStreak: 21);

    await tester.pumpWidget(buildCard(provider));
    await tester.pumpAndSettle();

    expect(find.text('STREAK'), findsOneWidget);
    expect(find.text('14 Hari'), findsOneWidget);
    expect(find.text('Terpanjang: 21 hari'), findsOneWidget);
  });

  testWidgets('shows Check-in button when not checked in today', (
    tester,
  ) async {
    var tapped = false;
    final provider = FakeCheckinProvider(
      currentStreak: 5,
      longestStreak: 10,
      todayCheckin: null,
    );

    await tester.pumpWidget(
      buildCard(provider, onCheckinTap: () => tapped = true),
    );
    await tester.pumpAndSettle();

    expect(find.text('Check-in'), findsOneWidget);
    await tester.tap(find.text('Check-in'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('shows Selesai badge when checked in clean today', (
    tester,
  ) async {
    final provider = FakeCheckinProvider(
      currentStreak: 6,
      longestStreak: 10,
      todayCheckin: const DailyCheckin(
        date: '2026-09-27',
        status: 'clean',
        xpEarned: 20,
      ),
    );

    await tester.pumpWidget(buildCard(provider));
    await tester.pumpAndSettle();

    expect(find.text('Selesai ✓'), findsOneWidget);
    expect(find.text('Check-in'), findsNothing);
  });

  testWidgets('shows Tercatat badge when checked in relapse today', (
    tester,
  ) async {
    final provider = FakeCheckinProvider(
      currentStreak: 0,
      longestStreak: 10,
      todayCheckin: const DailyCheckin(
        date: '2026-09-27',
        status: 'relapse',
        xpEarned: 0,
      ),
    );

    await tester.pumpWidget(buildCard(provider));
    await tester.pumpAndSettle();

    expect(find.text('Tercatat'), findsOneWidget);
    expect(find.text('Check-in'), findsNothing);
  });
}
