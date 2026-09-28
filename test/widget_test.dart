import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps [RewireApp] with a router whose gate is unset, so the app opens on the
/// onboarding screen. These tests cover the onboarding UI carried over from
/// Task 1, now reached through the router.
Future<void> _pumpOnboarding(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  final GoRouter router = buildRouter(prefs);
  await tester.pumpWidget(RewireApp(router: router));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('light theme button label meets WCAG AA contrast', (
    tester,
  ) async {
    await _pumpOnboarding(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final style = app.theme!.elevatedButtonTheme.style!;
    final foreground = style.foregroundColor!.resolve({})!;
    final background = style.backgroundColor!.resolve({})!;

    expect(_contrastRatio(foreground, background), greaterThanOrEqualTo(4.5));
  });

  testWidgets('onboarding shows its actions only on the final page', (
    tester,
  ) async {
    await _pumpOnboarding(tester);

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.byKey(const Key('welcome-brain')), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Start Journey'), findsNothing);
    // Skip is available from the first page.
    expect(find.text('Skip'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Three Pillars of Rewire'), findsOneWidget);
    expect(find.text('Start Journey'), findsNothing);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Level Up Your Brain'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Set Daily Reminders'), findsOneWidget);
    expect(find.text('Start Journey'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('swipe keeps each slide whole until the fade transition', (
    tester,
  ) async {
    await _pumpOnboarding(tester);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('onboarding-pages'))),
    );
    await gesture.moveBy(const Offset(-250, 0));
    await tester.pump();

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.text('Three Pillars of Rewire'), findsNothing);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Three Pillars of Rewire'), findsOneWidget);
    expect(find.text('Welcome to Rewire'), findsNothing);
  });

  testWidgets('onboarding pages can be advanced with the next control', (
    tester,
  ) async {
    await _pumpOnboarding(tester);

    for (final title in ['Three Pillars of Rewire', 'Level Up Your Brain']) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('onboarding scales to short screens without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpOnboarding(tester);

    expect(tester.takeException(), isNull);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = foreground.computeLuminance() > background.computeLuminance()
      ? foreground.computeLuminance()
      : background.computeLuminance();
  final darker = foreground.computeLuminance() > background.computeLuminance()
      ? background.computeLuminance()
      : foreground.computeLuminance();
  return (lighter + 0.05) / (darker + 0.05);
}
