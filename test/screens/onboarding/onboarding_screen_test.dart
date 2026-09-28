import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/app.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps the app on a fresh (not-onboarded) store so the gate opens onboarding.
/// Returns the [PreferenceService] the router and screen share.
Future<PreferenceService> _pumpFreshApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  final preferences = PreferenceService(prefs);
  final router = buildRouter(prefs, preferences: preferences);
  await tester.pumpWidget(RewireApp(router: router, preferences: preferences));
  await tester.pumpAndSettle();
  return preferences;
}

Future<void> _advanceToLastPage(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('starts on onboarding with default English language', (tester) async {
    await _pumpFreshApp(tester);
    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.text('Start your brain rewiring journey today.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.byKey(const Key('screen-home')), findsNothing);
  });

  testWidgets('completing the four pages sets the flag and enters the shell', (
    tester,
  ) async {
    final preferences = await _pumpFreshApp(tester);

    await _advanceToLastPage(tester);
    expect(find.text('Set Daily Reminders'), findsOneWidget);

    await tester.tap(find.text('Start Journey'));
    await tester.pumpAndSettle();

    // Transitions to /profile-setup; tapping Skip enters the home shell
    expect(find.byKey(const Key('setup-skip-button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('setup-skip-button')));
    await tester.pumpAndSettle();

    expect(preferences.onboardingCompleted, isTrue);
    expect(find.byKey(const Key('screen-home')), findsOneWidget);
    expect(find.text('Welcome to Rewire'), findsNothing);
  });

  testWidgets('Skip skips onboarding: transitions to setup, skip enters shell', (tester) async {
    final preferences = await _pumpFreshApp(tester);

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Transitions to /profile-setup; tapping Skip enters the home shell
    expect(find.byKey(const Key('setup-skip-button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('setup-skip-button')));
    await tester.pumpAndSettle();

    expect(preferences.onboardingCompleted, isTrue);
    expect(find.byKey(const Key('screen-home')), findsOneWidget);
  });

  testWidgets(
    'early pages show Next, final page shows the completion CTA',
    (tester) async {
      await _pumpFreshApp(tester);

      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Start Journey'), findsNothing);

      await _advanceToLastPage(tester);

      expect(find.text('Start Journey'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
    },
  );

  testWidgets('switching language to Indonesian translates onboarding carousel live', (tester) async {
    final preferences = await _pumpFreshApp(tester);

    // Initial state is English
    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.text('Start your brain rewiring journey today.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Switch to Indonesian
    await preferences.setLanguage('id');
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang di Rewire'), findsOneWidget);
    expect(find.text('Mulai perjalanan rewiring otakmu hari ini.'), findsOneWidget);
    expect(find.text('Selanjutnya'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
  });
}
