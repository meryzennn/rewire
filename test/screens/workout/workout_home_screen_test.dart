import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/data/routines.dart';
import 'package:rewire/providers/workout_provider.dart';
import 'package:rewire/screens/workout/workout_home_screen.dart';

class FakeWorkoutProvider extends ChangeNotifier implements WorkoutProvider {
  FakeWorkoutProvider({
    this.selectedCategory = 'Semua',
    this.totalMinutes = 180,
    this.sessionCount = 24,
  });

  @override
  String selectedCategory;

  @override
  int totalMinutes;

  @override
  int sessionCount;

  @override
  bool isLoadingStats = false;

  @override
  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  @override
  Future<void> loadStats() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget buildScreen(FakeWorkoutProvider provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<WorkoutProvider>.value(
      value: provider,
      child: WorkoutHomeScreen(provider: provider),
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

  testWidgets('renders all Stitch Workout Screen components', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Header
    expect(find.text('Latihan'), findsOneWidget);
    expect(find.byIcon(Icons.psychology), findsOneWidget);

    // 2. Neuroplasticity Boost banner
    expect(find.text('Neuro-Rewire Boost'), findsOneWidget);
    expect(find.text('+35 XP tiap sesi selesai'), findsOneWidget);

    // 3. Stats row
    expect(find.text('Total Sesi'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.text('Total Menit'), findsOneWidget);
    expect(find.text('180'), findsOneWidget);

    // 4. Routines section
    expect(find.text('Rutinitas'), findsOneWidget);
    for (final routine in kAllRoutines) {
      expect(find.text(routine.name), findsOneWidget);
      expect(find.text(routine.subtitle), findsOneWidget);
    }

    // 5. Category filter chips
    expect(find.text('Gerakan'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Upper'), findsOneWidget);
    expect(find.text('Lower'), findsOneWidget);
    expect(find.text('Core'), findsOneWidget);
    expect(find.text('Cardio'), findsOneWidget);

    // 6. Exercises listed
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
  });

  testWidgets('tapping category filter updates selectedCategory in provider', (
    tester,
  ) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedCategory, 'Semua');

    // Tap 'Upper' chip
    await tester.tap(find.text('Upper'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(provider.selectedCategory, 'Upper');

    // Now exercises list only has Upper exercises
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Knee Push-up'), findsOneWidget);
    expect(find.text('Squat'), findsNothing);
  });
}
