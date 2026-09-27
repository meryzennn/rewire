import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/core/theme/app_theme.dart';
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
    expect(find.text('Pejuang Rewire'), findsOneWidget);
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
}
