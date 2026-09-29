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

  testWidgets('Push-up exercise item displays pushup-5.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final pushupImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/pushup/pushup-5.png',
    );
    expect(pushupImage, findsOneWidget);
  });

  testWidgets('Knee Push-up exercise item displays knee-pushup_1.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final kneePushupImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/knee-pushup/knee-pushup_1.png',
    );
    expect(kneePushupImage, findsOneWidget);
  });

  testWidgets('Diamond Push-up exercise item displays diamond-pushup_2.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final diamondPushupImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/diamond-pushup/diamond-pushup_2.png',
    );
    expect(diamondPushupImage, findsOneWidget);
  });

  testWidgets('Pike Push-up exercise item displays pike-pushup_2.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final pikePushupImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/pike-pushup/pike-pushup_2.png',
    );
    expect(pikePushupImage, findsOneWidget);
  });

  testWidgets('Squat exercise item displays squat_4.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final squatImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/squat/squat_4.png',
    );
    expect(squatImage, findsOneWidget);
  });

  testWidgets('Lunge exercise item displays lunge_3.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final lungeImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/lunge/lunge_3.png',
    );
    expect(lungeImage, findsOneWidget);
  });

  testWidgets('Jump Squat exercise item displays jump-squat_3.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final jumpSquatImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/jump-squat/jump-squat_3.png',
    );
    expect(jumpSquatImage, findsOneWidget);
  });

  testWidgets('Wall Sit exercise item displays wallsit_3.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final wallSitImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/wallsit/wallsit_3.png',
    );
    expect(wallSitImage, findsOneWidget);
  });

  testWidgets('Plank exercise item displays plank_2.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final plankImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/plank/plank_2.png',
    );
    expect(plankImage, findsOneWidget);
  });

  testWidgets('Crunch exercise item displays crunch_3.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final crunchImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/crunch/crunch_3.png',
    );
    expect(crunchImage, findsOneWidget);
  });

  testWidgets('Mountain Climber exercise item displays mountain-climber_6.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final mountainClimberImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/mountain-climber/mountain-climber_6.png',
    );
    expect(mountainClimberImage, findsOneWidget);
  });

  testWidgets('Bicycle Crunch exercise item displays bicycle-crunch_5.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final bicycleCrunchImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/bicycle-crunch/bicycle-crunch_5.png',
    );
    expect(bicycleCrunchImage, findsOneWidget);
  });

  testWidgets('Jumping Jack exercise item displays jumping-jack_2.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final jumpingJackImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/jumping-jack/jumping-jack_2.png',
    );
    expect(jumpingJackImage, findsOneWidget);
  });

  testWidgets('High Knees exercise item displays high-knee_2.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final highKneesImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/high-knee/high-knee_2.png',
    );
    expect(highKneesImage, findsOneWidget);
  });

  testWidgets('Burpee exercise item displays burpee_6.png thumbnail', (tester) async {
    setViewport(tester);
    final provider = FakeWorkoutProvider();

    await tester.pumpWidget(buildScreen(provider));
    await tester.pump(const Duration(milliseconds: 100));

    final burpeeImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/exercises/burpee/burpee_6.png',
    );
    expect(burpeeImage, findsOneWidget);
  });
}
