import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/providers/user_provider.dart';
import 'package:rewire/screens/home/widgets/brain_visual.dart';

class FakeUserProvider extends ChangeNotifier implements UserProvider {
  FakeUserProvider({
    this.level = 12,
    this.totalXp = 3330,
    this.currentStreak = 14,
    this.longestStreak = 21,
    this.brainStage = 'awakening',
    this.levelProgress = 0.72,
    this.xpInLevel = 720,
    this.xpSpan = 1000,
  });

  @override
  int level;
  @override
  int totalXp;
  @override
  int currentStreak;
  @override
  int longestStreak;
  @override
  String brainStage;
  @override
  double levelProgress;
  @override
  int xpInLevel;
  @override
  int xpSpan;

  @override
  bool isLoading = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildWidget(FakeUserProvider provider) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<UserProvider>.value(
          value: provider,
          child: BrainVisual(provider: provider),
        ),
      ),
    );
  }

  testWidgets('renders level, stage, and XP progress bar matching Stitch', (
    tester,
  ) async {
    final provider = FakeUserProvider(
      level: 12,
      brainStage: 'awakening',
      xpInLevel: 720,
      xpSpan: 1000,
    );

    await tester.pumpWidget(buildWidget(provider));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Level 12'), findsOneWidget);
    expect(find.text('AWAKENING'), findsOneWidget);
    expect(find.text('Brain Rewiring Progress'), findsOneWidget);
    expect(find.text('720 / 1000 XP'), findsOneWidget);

    // Image asset for stage is rendered
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('renders styled fallback when brain stage asset is missing', (
    tester,
  ) async {
    final provider = FakeUserProvider(brainStage: 'missing_stage');

    await tester.pumpWidget(buildWidget(provider));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.psychology), findsOneWidget);
  });

  testWidgets('tapping opens the brain evolution stage timeline sheet', (
    tester,
  ) async {
    final provider = FakeUserProvider(level: 6, brainStage: 'awakening');

    await tester.pumpWidget(buildWidget(provider));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Level 6'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(
      find.text('Tahapan Evolusi Otak (Neuroplastisitas)'),
      findsOneWidget,
    );
    expect(find.text('DORMANT'), findsOneWidget);
    expect(find.text('AWAKENING'), findsWidgets);
    expect(find.text('GROWING'), findsOneWidget);
    expect(find.text('THRIVING'), findsOneWidget);
    expect(find.text('TRANSCENDENT'), findsOneWidget);
  });
}
