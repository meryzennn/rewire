import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/data/routines.dart';

void main() {
  group('Exercises data (spec §4.1)', () {
    test('contains all 15 canonical exercises with valid fields', () {
      expect(kAllExercises.length, 15);

      final categories = kAllExercises.map((e) => e.category).toSet();
      expect(categories, containsAll(['Upper', 'Lower', 'Core', 'Cardio']));

      for (final exercise in kAllExercises) {
        expect(exercise.id.isNotEmpty, isTrue);
        expect(exercise.name.isNotEmpty, isTrue);
        expect(exercise.defaultSets, greaterThan(0));
        expect(exercise.defaultReps, greaterThan(0));
        expect(exercise.targetMuscles.isNotEmpty, isTrue);
        expect(exercise.description.isNotEmpty, isTrue);
        expect(['Beginner', 'Intermediate'], contains(exercise.difficulty));
        expect(['Repetisi', 'Detik', 'Repetisi / sisi'], contains(exercise.unit));
      }
    });

    test('findExerciseById returns corresponding exercise or null', () {
      expect(findExerciseById('pushup')?.name, 'Push-up');
      expect(findExerciseById('squat')?.category, 'Lower');
      expect(findExerciseById('plank')?.isTimed, isTrue);
      expect(findExerciseById('unknown_id'), isNull);
    });
  });

  group('Workout Routines data (spec §4.2)', () {
    test('contains all 3 canonical routines with correct duration and exercises', () {
      expect(kAllRoutines.length, 3);

      final morning = findRoutineById('morning_energy');
      expect(morning, isNotNull);
      expect(morning!.name, 'Morning Energy');
      expect(morning.durationMinutes, 15);
      expect(morning.difficulty, 'Beginner');
      expect(morning.exerciseIds.length, 6);
      expect(morning.exercises.length, 6);
      expect(morning.xp, 25);

      final fullBody = findRoutineById('full_body_burn');
      expect(fullBody, isNotNull);
      expect(fullBody!.name, 'Full Body Burn');
      expect(fullBody.durationMinutes, 20);
      expect(fullBody.difficulty, 'Intermediate');
      expect(fullBody.exerciseIds.length, 8);
      expect(fullBody.exercises.length, 8);
      expect(fullBody.xp, 30);

      final core = findRoutineById('core_crusher');
      expect(core, isNotNull);
      expect(core!.name, 'Core Crusher');
      expect(core.durationMinutes, 10);
      expect(core.difficulty, 'Beginner');
      expect(core.exerciseIds.length, 5);
      expect(core.exercises.length, 5);
      expect(core.xp, 15);
    });

    test('findRoutineById returns null for unknown id', () {
      expect(findRoutineById('non_existent'), isNull);
    });
  });
}
