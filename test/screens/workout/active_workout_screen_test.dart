import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rewire/data/routines.dart';
import 'package:rewire/providers/workout_provider.dart';
import 'package:rewire/screens/workout/active_workout_screen.dart';
import 'package:rewire/services/xp_service.dart';

class FakeActiveWorkoutProvider extends ChangeNotifier
    implements WorkoutProvider {
  bool completeWorkoutCalled = false;
  String? lastRoutineId;

  @override
  Future<XpAward> completeWorkout({
    required String routineId,
    required String routineName,
    required int durationSeconds,
    required int exercisesCompleted,
    required int exercisesTotal,
    DateTime? now,
  }) async {
    completeWorkoutCalled = true;
    lastRoutineId = routineId;
    return const XpAward(
      amount: 25,
      totalXpBefore: 0,
      totalXpAfter: 25,
      levelBefore: 1,
      levelAfter: 1,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// A mini 1-exercise, 1-set test routine to test full completion flow without tapping 20 times
const WorkoutRoutine kMiniRoutine = WorkoutRoutine(
  id: 'mini_test',
  name: 'Mini Test Routine',
  subtitle: 'Tes singkat',
  durationMinutes: 5,
  difficulty: 'Beginner',
  exerciseIds: ['jumping_jack'],
  description: 'Rutinitas tes singkat 1 gerakan',
);

void main() {
  void setViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets(
    'renders active workout and transitions to rest on set complete',
    (tester) async {
      setViewport(tester);
      final provider = FakeActiveWorkoutProvider();
      final routine =
          kAllRoutines.first; // Morning Energy (6 exercises, each 3 sets)

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkoutProvider>.value(
            value: provider,
            child: ActiveWorkoutScreen(routine: routine, provider: provider),
          ),
        ),
      );

      // Initial state: Exercise 1 (Jumping Jack), Set 1 / 3
      expect(find.text('Morning Energy'), findsOneWidget);
      expect(find.text('Gerakan 1 / 6'), findsOneWidget);
      expect(find.text('Jumping Jack'), findsOneWidget);
      expect(find.text('Set 1 / 3'), findsOneWidget);
      expect(
        find.byKey(const Key('active-workout-complete-set-button')),
        findsOneWidget,
      );

      // Complete Set 1 -> transitions to rest
      await tester.tap(
        find.byKey(const Key('active-workout-complete-set-button')),
      );
      await tester.pump();

      // Now in Rest State
      expect(find.text('Istirahat'), findsOneWidget);
      expect(find.byKey(const Key('skip-rest-button')), findsOneWidget);

      // Skip Rest -> transitions back to Set 2
      await tester.tap(find.byKey(const Key('skip-rest-button')));
      await tester.pump();

      expect(find.text('Set 2 / 3'), findsOneWidget);
    },
  );

  testWidgets('tapping Batal shows confirmation dialog', (tester) async {
    setViewport(tester);
    final provider = FakeActiveWorkoutProvider();
    final routine = kAllRoutines.first;

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<WorkoutProvider>.value(
          value: provider,
          child: ActiveWorkoutScreen(routine: routine, provider: provider),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('active-workout-cancel-button')));
    await tester.pump();

    expect(find.text('Batalkan Latihan?'), findsOneWidget);
    expect(find.text('Lanjut Latihan'), findsOneWidget);
    expect(find.text('Ya, Batalkan'), findsOneWidget);

    // Tap dismiss
    await tester.tap(find.text('Lanjut Latihan'));
    await tester.pump();

    expect(find.text('Batalkan Latihan?'), findsNothing);
  });

  testWidgets('completing final set finishes workout and calls provider', (
    tester,
  ) async {
    setViewport(tester);
    final provider = FakeActiveWorkoutProvider();

    // With kMiniRoutine (1 exercise with default 3 sets):
    // We will advance set 1 -> rest -> set 2 -> rest -> set 3 -> finish!
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<WorkoutProvider>.value(
          value: provider,
          child: ActiveWorkoutScreen(routine: kMiniRoutine, provider: provider),
        ),
      ),
    );

    // Set 1 complete -> rest
    await tester.tap(
      find.byKey(const Key('active-workout-complete-set-button')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('skip-rest-button')));
    await tester.pump();

    // Set 2 complete -> rest
    await tester.tap(
      find.byKey(const Key('active-workout-complete-set-button')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('skip-rest-button')));
    await tester.pump();

    // Set 3: Last set of last exercise!
    expect(find.text('Selesai Latihan ✓'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('active-workout-complete-set-button')),
    );
    await tester.pumpAndSettle();

    expect(provider.completeWorkoutCalled, isTrue);
    expect(provider.lastRoutineId, 'mini_test');
    expect(find.text('Workout Selesai! 💪'), findsOneWidget);
  });
}
