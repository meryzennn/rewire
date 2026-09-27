import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/app.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Harness {
  _Harness(this.preferences, this.resetCalls);
  final PreferenceService preferences;
  final List<void> resetCalls;
}

/// Pumps the app already onboarded, then navigates to the settings tab.
Future<_Harness> _pumpSettings(
  WidgetTester tester, {
  Map<String, Object> seed = const {},
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_completed': true,
    ...seed,
  });
  final prefs = await SharedPreferences.getInstance();
  final preferences = PreferenceService(prefs);
  final resetCalls = <void>[];
  final GoRouter router = buildRouter(
    prefs,
    preferences: preferences,
    onResetData: () async => resetCalls.add(null),
  );
  await tester.pumpWidget(RewireApp(router: router, preferences: preferences));
  await tester.pumpAndSettle();
  router.go('/settings');
  await tester.pumpAndSettle();
  return _Harness(preferences, resetCalls);
}

ThemeMode _themeMode(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

/// Scrolls a row into view (the list lazily builds rows) before tapping it.
Future<void> _tapKey(WidgetTester tester, Key key) async {
  await tester.scrollUntilVisible(
    find.byKey(key),
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the Stitch settings sections', (tester) async {
    await _pumpSettings(tester);
    expect(find.text('Pengaturan'), findsWidgets); // app bar + nav tab label
    expect(find.text('Tampilan'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Mode Gelap'), findsOneWidget);
    expect(find.text('Reset Semua Data'), findsOneWidget);
  });

  testWidgets('dark-mode toggle drives themeMode and persists', (tester) async {
    final h = await _pumpSettings(tester);
    expect(_themeMode(tester), ThemeMode.system);

    await _tapKey(tester, const Key('toggle-dark-mode'));

    expect(h.preferences.themeMode, ThemeMode.dark);
    expect(_themeMode(tester), ThemeMode.dark);
  });

  testWidgets('daily reminder toggle persists', (tester) async {
    final h = await _pumpSettings(tester);
    expect(h.preferences.dailyReminderEnabled, isFalse);

    await _tapKey(tester, const Key('toggle-daily-reminder'));

    expect(h.preferences.dailyReminderEnabled, isTrue);
  });

  testWidgets('reminder time shows the persisted value', (tester) async {
    await _pumpSettings(tester, seed: {'daily_reminder_time': '21:30'});
    expect(find.text('21:30'), findsOneWidget);
  });

  testWidgets('reset asks for confirmation; cancel wipes nothing', (
    tester,
  ) async {
    final h = await _pumpSettings(tester);

    await _tapKey(tester, const Key('reset-data'));
    expect(find.text('Reset Semua Data?'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(h.resetCalls, isEmpty);
    expect(h.preferences.onboardingCompleted, isTrue);
    expect(find.text('Reset Semua Data?'), findsNothing); // dialog dismissed
    expect(find.text('Tampilan'), findsOneWidget); // still on settings
  });

  testWidgets('reset confirm clears data + prefs and returns to onboarding', (
    tester,
  ) async {
    final h = await _pumpSettings(tester, seed: {'dark_mode': true});

    await _tapKey(tester, const Key('reset-data'));
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(h.resetCalls, hasLength(1)); // DB wipe invoked
    expect(h.preferences.onboardingCompleted, isFalse); // prefs cleared
    expect(find.text('Welcome to Rewire'), findsOneWidget); // back to onboarding
  });
}
