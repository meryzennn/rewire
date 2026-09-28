import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/providers/checkin_provider.dart';
import 'package:rewire/screens/checkin/checkin_screen.dart';

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

  var submitCalled = false;
  String? lastStatus;
  int? lastMood;
  String? lastNotes;
  List<String>? lastTriggers;

  @override
  Future<DailyCheckin> submitCheckin({
    required String status,
    int? mood,
    String? notes,
    List<String> triggers = const [],
    DateTime? now,
  }) async {
    submitCalled = true;
    lastStatus = status;
    lastMood = mood;
    lastNotes = notes;
    lastTriggers = triggers;
    todayCheckin = DailyCheckin(
      date: '2026-09-27',
      status: status,
      mood: mood,
      notes: notes,
      xpEarned: status == 'clean' ? 20 : 0,
    );
    todayTriggers = triggers;
    notifyListeners();
    return todayCheckin!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildScreen(FakeCheckinProvider provider) {
    return MaterialApp(
      home: ChangeNotifierProvider<CheckinProvider>.value(
        value: provider,
        child: CheckinScreen(provider: provider),
      ),
    );
  }

  testWidgets('renders all Stitch Daily Check-in screen components', (
    tester,
  ) async {
    final provider = FakeCheckinProvider(currentStreak: 14, longestStreak: 20);

    await tester.pumpWidget(buildScreen(provider));
    await tester.pumpAndSettle();

    // App Bar
    expect(find.text('Check-in Harian'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);

    // Date & Streak Header
    expect(find.text('Streak Berjalan'), findsOneWidget);
    expect(find.text('Hari ke-15'), findsOneWidget);
    expect(find.text('bersih tanpa distraksi'), findsOneWidget);

    // Status Cards
    expect(find.text('Bagaimana hari ini?'), findsOneWidget);
    expect(find.text('Hari yang Bersih'), findsOneWidget);
    expect(find.text('Relapse Hari ini'), findsOneWidget);

    // Mood Section
    expect(find.text('Mood kamu hari ini?'), findsOneWidget);
    expect(find.text('Kacau'), findsOneWidget);
    expect(find.text('Cemas'), findsOneWidget);
    expect(find.text('Biasa'), findsOneWidget);
    expect(find.text('Tenang'), findsOneWidget);
    expect(find.text('Penuh Daya'), findsOneWidget);

    // Clean status by default: trigger chips should NOT appear
    expect(find.text('Pemicu (trigger) relapse?'), findsNothing);
    expect(
      find.text('Catatan & Rasa Syukur Hari Ini (Opsional)'),
      findsOneWidget,
    );

    // Switching to Relapse reveals trigger section
    await tester.tap(find.text('Relapse Hari ini'));
    await tester.pumpAndSettle();
    expect(find.text('Pemicu (trigger) relapse?'), findsOneWidget);
    expect(find.text('Opsional'), findsOneWidget);
    expect(find.text('Stres'), findsOneWidget);
    expect(find.text('Bosan'), findsOneWidget);

    // Action button & micro-copy
    expect(find.text('Simpan Check-in'), findsOneWidget);
    expect(
      find.text(
        'Satu langkah kecil sadar untuk membentuk jalur otak yang baru.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('allows selecting clean status, mood, and notes without triggers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = FakeCheckinProvider(currentStreak: 3, longestStreak: 5);

    await tester.pumpWidget(buildScreen(provider));
    await tester.pumpAndSettle();

    // Select mood: Tenang (value 4)
    await tester.tap(find.text('Tenang'));
    await tester.pumpAndSettle();

    // Enter notes
    await tester.enterText(
      find.byType(TextField),
      'Sedikit cemas tapi berhasil jalan santai.',
    );
    await tester.pumpAndSettle();

    // Submit clean checkin
    await tester.tap(find.text('Simpan Check-in'));
    await tester.pumpAndSettle();

    expect(provider.submitCalled, isTrue);
    expect(provider.lastStatus, 'clean');
    expect(provider.lastMood, 4);
    expect(provider.lastTriggers, isEmpty);
    expect(provider.lastNotes, 'Sedikit cemas tapi berhasil jalan santai.');
  });

  testWidgets('selecting relapse allows selecting triggers and notes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = FakeCheckinProvider(currentStreak: 3, longestStreak: 5);

    await tester.pumpWidget(buildScreen(provider));
    await tester.pumpAndSettle();

    // Select relapse
    await tester.tap(find.text('Relapse Hari ini'));
    await tester.pumpAndSettle();

    // Select triggers
    await tester.tap(find.text('Stres'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sosial Media'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.text('Simpan Check-in'));
    await tester.pumpAndSettle();

    expect(provider.submitCalled, isTrue);
    expect(provider.lastStatus, 'relapse');
    expect(provider.lastTriggers, containsAll(['Stres', 'Sosial Media']));
  });

  testWidgets(
    'submitting relapse displays compassionate encouragement dialog',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final provider = FakeCheckinProvider(
        currentStreak: 10,
        longestStreak: 10,
      );

      await tester.pumpWidget(buildScreen(provider));
      await tester.pumpAndSettle();

      // Select Relapse card
      await tester.tap(find.text('Relapse Hari ini'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Simpan Check-in'));
      await tester.pumpAndSettle();

      expect(provider.submitCalled, isTrue);
      expect(provider.lastStatus, 'relapse');

      // Encouragement dialog
      expect(find.text('Tidak apa-apa.'), findsOneWidget);
      expect(
        find.text(
          'Streak kamu akan direset, tapi total XP dan level tetap tersimpan utuh.',
        ),
        findsOneWidget,
      );
      expect(find.text('Mulai Lagi 💪'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Mulai Lagi 💪'));
      await tester.pumpAndSettle();

      expect(find.text('Tidak apa-apa.'), findsNothing);
    },
  );

  testWidgets(
    'pre-populates existing check-in data when already checked in today',
    (tester) async {
      final provider = FakeCheckinProvider(
        currentStreak: 7,
        longestStreak: 7,
        todayCheckin: const DailyCheckin(
          date: '2026-09-27',
          status: 'clean',
          mood: 5,
          notes: 'Hari yang sangat produktif!',
          xpEarned: 20,
        ),
        todayTriggers: ['Sosial Media'],
      );

      await tester.pumpWidget(buildScreen(provider));
      await tester.pumpAndSettle();

      expect(find.text('Kamu sudah check-in hari ini'), findsOneWidget);
      expect(find.text('Perbarui Check-in'), findsOneWidget);
      expect(find.text('Hari yang sangat produktif!'), findsOneWidget);
      expect(find.text('Hari ke-7'), findsOneWidget);
    },
  );
}
