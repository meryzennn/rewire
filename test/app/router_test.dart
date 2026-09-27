import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds a router whose onboarding gate reads a mocked SharedPreferences.
Future<GoRouter> _buildRouter({required bool onboarded}) async {
  SharedPreferences.setMockInitialValues(
    onboarded ? {kOnboardingCompletedKey: true} : {},
  );
  final prefs = await SharedPreferences.getInstance();
  return buildRouter(prefs);
}

Future<GoRouter> _pumpApp(WidgetTester tester, {required bool onboarded}) async {
  final router = await _buildRouter(onboarded: onboarded);
  await tester.pumpWidget(RewireApp(router: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  group('first-run onboarding gate', () {
    testWidgets('flag unset routes to onboarding', (tester) async {
      await _pumpApp(tester, onboarded: false);

      expect(find.text('Welcome to Rewire'), findsOneWidget);
      expect(find.byKey(const Key('screen-home')), findsNothing);
    });

    testWidgets('flag set routes to the main shell (home)', (tester) async {
      await _pumpApp(tester, onboarded: true);

      expect(find.byKey(const Key('screen-home')), findsOneWidget);
      expect(find.text('Welcome to Rewire'), findsNothing);
    });
  });

  group('route destinations resolve to the right screen', () {
    const destinations = {
      '/': 'screen-home',
      '/meditation': 'screen-meditation',
      '/workout': 'screen-workout',
      '/progress': 'screen-progress',
      '/settings': 'screen-settings',
    };

    testWidgets('each tab path renders its screen', (tester) async {
      final router = await _pumpApp(tester, onboarded: true);

      for (final entry in destinations.entries) {
        router.go(entry.key);
        await tester.pumpAndSettle();
        expect(
          find.byKey(Key(entry.value)),
          findsOneWidget,
          reason: '${entry.key} should show ${entry.value}',
        );
      }
    });
  });

  group('tab stack retention', () {
    testWidgets('switching tabs preserves each branch state', (tester) async {
      final router = await _pumpApp(tester, onboarded: true);

      // Grab the Home branch's State while it is the active tab.
      final homeState1 = tester.state(find.byKey(const Key('screen-home')));

      router.go('/settings');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('screen-settings')), findsOneWidget);

      // IndexedStack keeps inactive branches mounted (offstage), so the Home
      // branch's State survives the tab switch rather than being rebuilt.
      final homeFinder = find.byKey(const Key('screen-home'), skipOffstage: false);
      expect(homeFinder, findsOneWidget);
      final homeState2 = tester.state(homeFinder);
      expect(identical(homeState1, homeState2), isTrue);

      // Returning to Home shows the retained branch.
      router.go('/');
      await tester.pumpAndSettle();
      final homeState3 = tester.state(find.byKey(const Key('screen-home')));
      expect(identical(homeState1, homeState3), isTrue);
    });
  });

  group('swipe navigation between tabs', () {
    testWidgets('swiping horizontally transitions across tabs', (tester) async {
      await _pumpApp(tester, onboarded: true);
      expect(find.byKey(const Key('screen-home')), findsOneWidget);

      // Drag left from home to meditation
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('screen-meditation')), findsOneWidget);

      // Drag right from meditation back to home
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('screen-home')), findsOneWidget);
    });
  });
}
