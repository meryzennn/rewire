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
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('starts on onboarding when the flag is unset', (tester) async {
    await _pumpFreshApp(tester);
    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.byKey(const Key('screen-home')), findsNothing);
  });

  testWidgets('completing the four pages sets the flag and enters the shell', (
    tester,
  ) async {
    final preferences = await _pumpFreshApp(tester);

    await _advanceToLastPage(tester);
    expect(find.text('Atur Pengingat Harian'), findsOneWidget);

    await tester.tap(find.text('Mulai Perjalanan'));
    await tester.pumpAndSettle();

    expect(preferences.onboardingCompleted, isTrue);
    expect(find.byKey(const Key('screen-home')), findsOneWidget);
    expect(find.text('Welcome to Rewire'), findsNothing);
  });

  testWidgets('Lewati skips onboarding: flag set, shell shown', (tester) async {
    final preferences = await _pumpFreshApp(tester);

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();

    expect(preferences.onboardingCompleted, isTrue);
    expect(find.byKey(const Key('screen-home')), findsOneWidget);
  });

  testWidgets('early pages show Selanjutnya, final page shows the completion CTA', (
    tester,
  ) async {
    await _pumpFreshApp(tester);

    expect(find.text('Selanjutnya'), findsOneWidget);
    expect(find.text('Mulai Perjalanan'), findsNothing);

    await _advanceToLastPage(tester);

    expect(find.text('Mulai Perjalanan'), findsOneWidget);
    expect(find.text('Selanjutnya'), findsNothing);
  });
}
