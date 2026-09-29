import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/data/meditation_definitions.dart';
import 'package:rewire/l10n/app_localizations.dart';
import 'package:rewire/providers/meditation_provider.dart';
import 'package:rewire/screens/meditation/meditation_home_screen.dart';

class FakeMeditationProvider extends ChangeNotifier
    implements MeditationProvider {
  FakeMeditationProvider({
    this.selectedDurationMinutes = 10,
    this.selectedTrackId = 'rain',
    this.selectedBreathingId,
    this.totalMinutes = 45,
    this.sessionCount = 3,
  });

  @override
  int selectedDurationMinutes;

  @override
  String selectedTrackId;

  @override
  String? selectedBreathingId;

  @override
  int totalMinutes;

  @override
  int sessionCount;

  @override
  bool isLoadingStats = false;

  @override
  void setDuration(int minutes) {
    selectedDurationMinutes = minutes;
    notifyListeners();
  }

  @override
  void setTrack(String trackId) {
    selectedTrackId = trackId;
    notifyListeners();
  }

  @override
  void setBreathing(String? breathingId) {
    selectedBreathingId = breathingId;
    notifyListeners();
  }

  @override
  Future<void> loadStats() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget buildScreen(FakeMeditationProvider provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<MeditationProvider>.value(
      value: provider,
      child: MeditationHomeScreen(provider: provider),
    ),
  );
}

void main() {
  void setViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('renders all Stitch Meditasi Screen components', (tester) async {
    setViewport(tester);
    final provider = FakeMeditationProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Header & Hero
    expect(find.text('Meditasi'), findsOneWidget);
    expect(find.text('Tenangkan Pikiran'), findsOneWidget);
    expect(
      find.text(
        'Pilih suasana dan durasi meditasimu untuk merestorasi fokus hari ini.',
      ),
      findsOneWidget,
    );
    expect(find.text('🧘 45 menit · 3 sesi selesai'), findsOneWidget);

    // 2. Duration pills
    for (final duration in kMeditationDurations) {
      expect(find.text('$duration min'), findsOneWidget);
    }
    expect(find.text('Kustom ⏱️'), findsOneWidget);

    // 3. Sound cards (all 6)
    for (final track in kAmbientTracks) {
      expect(find.text(track.title), findsOneWidget);
      expect(find.text(track.emoji), findsOneWidget);
    }

    // 4. Breathing options
    expect(find.text('Bebas'), findsOneWidget);
    expect(find.text('Box'), findsOneWidget);
    expect(find.text('4-7-8'), findsOneWidget);

    // 5. Start button and XP hint
    expect(find.text('Mulai Meditasi'), findsOneWidget);
    expect(find.textContaining('+15 XP'), findsOneWidget);
  });

  testWidgets(
    'tapping duration pill updates selected duration and potential XP',
    (tester) async {
      setViewport(tester);
      final provider = FakeMeditationProvider(selectedDurationMinutes: 10);

      await tester.pumpWidget(buildScreen(provider));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('+15 XP'), findsOneWidget);

      // Tap 20 min pill
      await tester.tap(find.text('20 min'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(provider.selectedDurationMinutes, 20);
      expect(find.textContaining('+25 XP'), findsOneWidget);
    },
  );

  testWidgets('tapping sound card selects that track', (tester) async {
    setViewport(tester);
    final provider = FakeMeditationProvider(selectedTrackId: 'rain');

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedTrackId, 'rain');

    // Tap Ombak card
    await tester.tap(find.text('Ombak'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedTrackId, 'waves');
  });

  testWidgets('tapping breathing card updates breathing pattern', (
    tester,
  ) async {
    setViewport(tester);
    final provider = FakeMeditationProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedBreathingId, isNull);

    // Tap Box Breathing
    await tester.tap(find.text('Box'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedBreathingId, 'box');

    // Tap 4-7-8
    await tester.tap(find.text('4-7-8'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedBreathingId, '478');
  });

  testWidgets('renders session completed summary in English when en locale', (
    tester,
  ) async {
    setViewport(tester);
    final provider = FakeMeditationProvider(totalMinutes: 1, sessionCount: 1);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<MeditationProvider>.value(
          value: provider,
          child: MeditationHomeScreen(provider: provider),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('🧘 1 min · 1 sessions completed'), findsOneWidget);
  });
}
