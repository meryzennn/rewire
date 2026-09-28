import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/app.dart';
import 'package:rewire/screens/onboarding/initial_setup_screen.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PreferenceService> _createPrefService([
  Map<String, Object> initialValues = const {},
]) async {
  SharedPreferences.setMockInitialValues(initialValues);
  final prefs = await SharedPreferences.getInstance();
  return PreferenceService(prefs);
}

Future<void> _pumpSetupScreen(
  WidgetTester tester, {
  required PreferenceService prefService,
}) async {
  final GoRouter router = GoRouter(
    initialLocation: '/profile-setup',
    routes: [
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) =>
            InitialSetupScreen(preferences: prefService),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Text('Home Screen Placeholder')),
      ),
    ],
  );

  await tester.pumpWidget(
    RewireApp(router: router, preferences: prefService),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders all setup screen sections', (tester) async {
    final prefs = await _createPrefService();
    await _pumpSetupScreen(tester, prefService: prefs);

    expect(find.byKey(const Key('setup-skip-button')), findsOneWidget);
    expect(find.byKey(const Key('setup-continue-button')), findsOneWidget);
    expect(find.byKey(const Key('setup-name-input')), findsOneWidget);
    expect(find.byKey(const Key('setup-birthday-picker')), findsOneWidget);
    expect(find.byKey(const Key('setup-height-input')), findsOneWidget);
    expect(find.byKey(const Key('setup-weight-input')), findsOneWidget);
    expect(find.byKey(const Key('setup-fitness-beginner')), findsOneWidget);
    expect(find.byKey(const Key('setup-fitness-intermediate')), findsOneWidget);
    expect(find.byKey(const Key('setup-fitness-expert')), findsOneWidget);
  });

  testWidgets('tapping Skip sets onboardingCompleted and routes to home', (tester) async {
    final prefs = await _createPrefService();
    await _pumpSetupScreen(tester, prefService: prefs);

    expect(prefs.onboardingCompleted, isFalse);

    await tester.tap(find.byKey(const Key('setup-skip-button')));
    await tester.pumpAndSettle();

    expect(prefs.onboardingCompleted, isTrue);
    expect(find.text('Home Screen Placeholder'), findsOneWidget);
  });

  testWidgets('language chips switch language reactively', (tester) async {
    final prefs = await _createPrefService({'language': 'en'});
    await _pumpSetupScreen(tester, prefService: prefs);

    expect(prefs.language, 'en');

    // Tap Indonesian chip
    await tester.tap(find.byKey(const Key('lang-chip-id')));
    await tester.pumpAndSettle();

    expect(prefs.language, 'id');

    // Tap Spanish chip
    await tester.tap(find.byKey(const Key('lang-chip-es')));
    await tester.pumpAndSettle();

    expect(prefs.language, 'es');

    // Tap Japanese chip
    await tester.tap(find.byKey(const Key('lang-chip-ja')));
    await tester.pumpAndSettle();

    expect(prefs.language, 'ja');
  });

  testWidgets('live BMI indicator calculates and updates status pill', (tester) async {
    final prefs = await _createPrefService();
    await _pumpSetupScreen(tester, prefService: prefs);

    // Enter height 170 and weight 95 (BMI = 32.9 Obese)
    await tester.enterText(find.byKey(const Key('setup-height-input')), '170');
    await tester.enterText(find.byKey(const Key('setup-weight-input')), '95');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('setup-bmi-indicator')), findsOneWidget);
    expect(find.textContaining('32.9'), findsOneWidget);

    // Change weight to 65 (BMI = 22.5 Normal)
    await tester.enterText(find.byKey(const Key('setup-weight-input')), '65');
    await tester.pumpAndSettle();

    expect(find.textContaining('22.5'), findsOneWidget);
  });

  testWidgets('filling form and tapping Continue persists preferences and navigates', (tester) async {
    final prefs = await _createPrefService();
    await _pumpSetupScreen(tester, prefService: prefs);

    // Enter name
    await tester.enterText(find.byKey(const Key('setup-name-input')), 'Alex Walker');
    await tester.enterText(find.byKey(const Key('setup-height-input')), '175');
    await tester.enterText(find.byKey(const Key('setup-weight-input')), '70');

    // Select intermediate fitness level
    await tester.ensureVisible(find.byKey(const Key('setup-fitness-intermediate')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('setup-fitness-intermediate')));
    await tester.pumpAndSettle();

    // Tap continue
    await tester.tap(find.byKey(const Key('setup-continue-button')));
    await tester.pumpAndSettle();

    expect(prefs.onboardingCompleted, isTrue);
    expect(prefs.userName, 'Alex Walker');
    expect(prefs.userHeight, 175.0);
    expect(prefs.userWeight, 70.0);
    expect(prefs.userFitnessLevel, 'intermediate');
    expect(find.text('Home Screen Placeholder'), findsOneWidget);
  });

  testWidgets('selecting birthday calculates dynamic age and formats display', (tester) async {
    final prefs = await _createPrefService();
    await _pumpSetupScreen(tester, prefService: prefs);

    // Initial state has birthday label
    expect(find.byKey(const Key('setup-birthday-picker')), findsOneWidget);

    // Tap birthday picker to open DatePicker
    await tester.tap(find.byKey(const Key('setup-birthday-picker')));
    await tester.pumpAndSettle();

    // In DatePickerDialog, confirm selection
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify birthday formatted text appears with age
    expect(find.textContaining('years old'), findsOneWidget);
  });
}
