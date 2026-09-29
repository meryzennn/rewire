import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/core/theme/app_theme.dart';
import 'package:rewire/providers/user_provider.dart';
import 'package:rewire/screens/profile/profile_screen.dart';
import 'package:rewire/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders profile avatar, name, and physical stats correctly', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Ahmad',
      'user_age': 25,
      'user_height': 172.0,
      'user_weight': 68.0,
    });
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: ProfileScreen(
          preferences: prefService,
          onResetData: () async {},
        ),
      ),
    );

    // Name & Header
    expect(find.text('Ahmad'), findsOneWidget);
    expect(find.byKey(const Key('btn-change-pfp')), findsOneWidget);

    final avatarFinder = find.byType(CircleAvatar).first;
    final nameFinder = find.text('Ahmad');
    expect(
      tester.getCenter(nameFinder).dx,
      closeTo(tester.getCenter(avatarFinder).dx, 1.0),
    );

    // Physical Stats
    expect(find.text('DATA FISIK'), findsOneWidget);
    expect(find.text('25 Thn'), findsOneWidget);
    expect(find.text('172 cm'), findsOneWidget);
    expect(find.text('68 kg'), findsOneWidget);

    // Embedded settings
    expect(find.text('Tampilan'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Data'), findsOneWidget);
  });

  testWidgets('editing profile and physical stats persists and updates UI', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: ProfileScreen(
            preferences: prefService,
            onResetData: () async {},
          ),
        ),
      ),
    );

    // Initially default name and '-' for physical stats
    expect(find.text('Anon'), findsOneWidget);
    expect(find.text('-'), findsNWidgets(3));

    // Tap "Ubah" button
    await tester.tap(find.byKey(const Key('btn-edit-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil & Data Fisik'), findsOneWidget);

    // Fill in fields
    await tester.enterText(
      find.byKey(const Key('input-profile-name')),
      'Satria Baja Hitam',
    );
    await tester.enterText(find.byKey(const Key('input-profile-age')), '28');
    await tester.enterText(
      find.byKey(const Key('input-profile-height')),
      '178',
    );
    await tester.enterText(find.byKey(const Key('input-profile-weight')), '74');

    // Tap Simpan Perubahan
    await tester.tap(find.byKey(const Key('btn-save-profile')));
    await tester.pumpAndSettle();

    // Verify dialog dismissed and new values appear
    expect(find.text('Edit Profil & Data Fisik'), findsNothing);
    expect(find.text('Satria Baja Hitam'), findsOneWidget);
    expect(find.text('28 Thn'), findsOneWidget);
    expect(find.text('178 cm'), findsOneWidget);
    expect(find.text('74 kg'), findsOneWidget);

    // Verify persisted in preferences
    expect(prefService.userName, 'Satria Baja Hitam');
    expect(prefService.userAge, 28);
    expect(prefService.userHeight, 178.0);
    expect(prefService.userWeight, 74.0);
  });

  testWidgets('tapping pencil icon under PFP opens edit name dialog and updates name', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'user_name': 'Budi'});
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: ProfileScreen(
            preferences: prefService,
            onResetData: () async {},
          ),
        ),
      ),
    );

    // Initial name and pencil icon
    expect(find.text('Budi'), findsOneWidget);
    expect(find.byKey(const Key('btn-edit-name')), findsOneWidget);
    expect(find.byIcon(Icons.edit_rounded), findsWidgets);

    // Tap pencil icon button
    await tester.tap(find.byKey(const Key('btn-edit-name')));
    await tester.pumpAndSettle();

    // Dialog opens
    expect(find.text('Ubah Nama'), findsOneWidget);
    expect(find.byKey(const Key('input-edit-name')), findsOneWidget);

    // Enter new name and save
    await tester.enterText(
      find.byKey(const Key('input-edit-name')),
      'Budi Prakoso',
    );
    await tester.tap(find.byKey(const Key('btn-save-name')));
    await tester.pumpAndSettle();

    // Dialog dismissed and UI updated
    expect(find.text('Ubah Nama'), findsNothing);
    expect(find.text('Budi Prakoso'), findsOneWidget);
    expect(prefService.userName, 'Budi Prakoso');
  });

  testWidgets('reset all data reloads in-memory UserProvider and resets stats', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Budi',
      'user_age': 25,
      'onboarding_completed': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);
    final userProvider = _TestUserProvider();
    var resetDbCalled = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider?>.value(
        value: userProvider,
        child: MaterialApp(
          theme: buildLightTheme(),
          home: Scaffold(
            body: ProfileScreen(
              preferences: prefService,
              onResetData: () async {
                resetDbCalled = true;
              },
            ),
          ),
        ),
      ),
    );

    // Initial state: Level 5, 10 Hari streak
    expect(find.text('Level 5'), findsOneWidget);
    expect(find.text('10 Hari'), findsOneWidget);

    // Scroll to and tap Reset Semua Data
    await tester.scrollUntilVisible(
      find.byKey(const Key('reset-data')),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reset-data')));
    await tester.pumpAndSettle();

    // Confirm dialog
    expect(find.text('Reset Semua Data?'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Verify DB wiped, provider reloaded, preferences cleared
    expect(resetDbCalled, isTrue);
    expect(userProvider.loadProfileCalls, 1);
    expect(userProvider.level, 1);
    expect(userProvider.currentStreak, 0);
    expect(userProvider.totalXp, 0);
    expect(prefService.onboardingCompleted, isFalse);
    expect(prefService.userName, isEmpty);
  });

  testWidgets('tapping language row opens selector and updates language preference', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'language': 'id'});
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: ProfileScreen(
            preferences: prefService,
            onResetData: () async {},
          ),
        ),
      ),
    );

    // Initial state: Bahasa Indonesia
    expect(find.text('Bahasa'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);

    // Tap language row
    await tester.ensureVisible(find.byKey(const Key('row-select-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('row-select-language')));
    await tester.pumpAndSettle();

    // Modal sheet opens with language options
    expect(find.text('Pilih Bahasa / Select Language'), findsOneWidget);
    expect(find.byKey(const Key('lang-option-en')), findsOneWidget);
    expect(find.byKey(const Key('lang-option-es')), findsOneWidget);

    // Select English
    await tester.tap(find.byKey(const Key('lang-option-en')));
    await tester.pumpAndSettle();

    // Verify modal dismissed, language updated in preferences and UI
    expect(find.text('Pilih Bahasa / Select Language'), findsNothing);
    expect(prefService.language, 'en');
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('renders birthday, dynamic age, fitness level chip, and BMI badge', (
    tester,
  ) async {
    final now = DateTime.now();
    final birthYear = now.year - 26;
    SharedPreferences.setMockInitialValues({
      'user_name': 'Budi',
      'user_birth_date': '$birthYear-05-15',
      'user_fitness_level': 'intermediate',
      'user_height': 175.0,
      'user_weight': 70.0,
    });
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: ProfileScreen(
            preferences: prefService,
            onResetData: () async {},
          ),
        ),
      ),
    );

    // Fitness level chip in avatar header
    expect(find.byKey(const Key('chip-fitness-level')), findsOneWidget);
    expect(find.text('Intermediate'), findsOneWidget);

    // Physical stats: Dynamic age, Birthday tile, BMI badge
    expect(find.textContaining('15 May $birthYear'), findsOneWidget);
    // Calculated age should be 25 or 26 depending on month
    expect(find.textContaining('${prefService.userAge} Thn'), findsOneWidget);

    // BMI badge (70 / (1.75^2) = 22.86 -> 22.9 Normal)
    expect(find.byKey(const Key('badge-bmi')), findsOneWidget);
    expect(find.textContaining('22.9'), findsOneWidget);
    expect(find.textContaining('Normal'), findsOneWidget);
  });

  testWidgets('editing profile allows updating birthday and fitness level', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Charlie',
      'user_fitness_level': 'beginner',
    });
    final prefs = await SharedPreferences.getInstance();
    final prefService = PreferenceService(prefs);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: ProfileScreen(
            preferences: prefService,
            onResetData: () async {},
          ),
        ),
      ),
    );

    expect(find.text('Beginner'), findsOneWidget);

    // Tap Ubah button to open bottom sheet
    await tester.tap(find.byKey(const Key('btn-edit-profile')));
    await tester.pumpAndSettle();

    // Verify Birthday picker tile and Fitness Level selector exist
    expect(find.byKey(const Key('input-profile-birthday')), findsOneWidget);
    expect(find.byKey(const Key('select-fitness-beginner')), findsOneWidget);
    expect(find.byKey(const Key('select-fitness-intermediate')), findsOneWidget);
    expect(find.byKey(const Key('select-fitness-expert')), findsOneWidget);

    // Tap Expert chip
    await tester.tap(find.byKey(const Key('select-fitness-expert')));
    await tester.pumpAndSettle();

    // Tap Birthday picker to open DatePicker
    await tester.tap(find.byKey(const Key('input-profile-birthday')));
    await tester.pumpAndSettle();

    // Confirm date picker dialog is open and tap OK
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Save changes
    await tester.tap(find.byKey(const Key('btn-save-profile')));
    await tester.pumpAndSettle();

    // Verify persisted
    expect(prefService.userFitnessLevel, 'expert');
    expect(prefService.userBirthDate, isNotNull);
    expect(find.text('Expert'), findsOneWidget);
  });
}

class _TestUserProvider extends ChangeNotifier implements UserProvider {
  int loadProfileCalls = 0;
  @override
  int level = 5;
  @override
  int currentStreak = 10;
  @override
  int totalXp = 500;

  @override
  Future<void> loadProfile() async {
    loadProfileCalls++;
    level = 1;
    currentStreak = 0;
    totalXp = 0;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

