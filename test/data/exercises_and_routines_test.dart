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
        expect([
          'Repetisi',
          'Detik',
          'Repetisi / sisi',
        ], contains(exercise.unit));
      }
    });

    test('findExerciseById returns corresponding exercise or null', () {
      expect(findExerciseById('pushup')?.name, 'Push-up');
      expect(findExerciseById('squat')?.category, 'Lower');
      expect(findExerciseById('plank')?.isTimed, isTrue);
      expect(findExerciseById('unknown_id'), isNull);
    });

    test('pushup exercise has custom iconAssetPath and 6 animation frames', () {
      final pushup = findExerciseById('pushup');
      expect(pushup, isNotNull);
      expect(pushup!.iconAssetPath, 'assets/images/exercises/pushup/pushup-5.png');
      expect(pushup.animationFrames, [
        'assets/images/exercises/pushup/pushup-1.png',
        'assets/images/exercises/pushup/pushup-2.png',
        'assets/images/exercises/pushup/pushup-3.png',
        'assets/images/exercises/pushup/pushup-4.png',
        'assets/images/exercises/pushup/pushup-5.png',
        'assets/images/exercises/pushup/pushup-6.png',
      ]);
    });

    test('knee_pushup exercise has custom iconAssetPath and 6 animation frames', () {
      final kneePushup = findExerciseById('knee_pushup');
      expect(kneePushup, isNotNull);
      expect(kneePushup!.iconAssetPath, 'assets/images/exercises/knee-pushup/knee-pushup_1.png');
      expect(kneePushup.animationFrames, [
        'assets/images/exercises/knee-pushup/knee-pushup_1.png',
        'assets/images/exercises/knee-pushup/knee-pushup_2.png',
        'assets/images/exercises/knee-pushup/knee-pushup_3.png',
        'assets/images/exercises/knee-pushup/knee-pushup_4.png',
        'assets/images/exercises/knee-pushup/knee-pushup_5.png',
        'assets/images/exercises/knee-pushup/knee-pushup_6.png',
      ]);
    });

    test('diamond_pushup exercise has custom iconAssetPath and 6 animation frames', () {
      final diamondPushup = findExerciseById('diamond_pushup');
      expect(diamondPushup, isNotNull);
      expect(diamondPushup!.iconAssetPath, 'assets/images/exercises/diamond-pushup/diamond-pushup_2.png');
      expect(diamondPushup.animationFrames, [
        'assets/images/exercises/diamond-pushup/diamond-pushup_1.png',
        'assets/images/exercises/diamond-pushup/diamond-pushup_2.png',
        'assets/images/exercises/diamond-pushup/diamond-pushup_3.png',
        'assets/images/exercises/diamond-pushup/diamond-pushup_4.png',
        'assets/images/exercises/diamond-pushup/diamond-pushup_5.png',
        'assets/images/exercises/diamond-pushup/diamond-pushup_6.png',
      ]);
    });

    test('pike_pushup exercise has custom iconAssetPath and 6 animation frames', () {
      final pikePushup = findExerciseById('pike_pushup');
      expect(pikePushup, isNotNull);
      expect(pikePushup!.iconAssetPath, 'assets/images/exercises/pike-pushup/pike-pushup_2.png');
      expect(pikePushup.animationFrames, [
        'assets/images/exercises/pike-pushup/pike-pushup_1.png',
        'assets/images/exercises/pike-pushup/pike-pushup_2.png',
        'assets/images/exercises/pike-pushup/pike-pushup_3.png',
        'assets/images/exercises/pike-pushup/pike-pushup_4.png',
        'assets/images/exercises/pike-pushup/pike-pushup_5.png',
        'assets/images/exercises/pike-pushup/pike-pushup_6.png',
      ]);
    });

    test('squat exercise has custom iconAssetPath and 6 animation frames', () {
      final squat = findExerciseById('squat');
      expect(squat, isNotNull);
      expect(squat!.iconAssetPath, 'assets/images/exercises/squat/squat_4.png');
      expect(squat.animationFrames, [
        'assets/images/exercises/squat/squat_1.png',
        'assets/images/exercises/squat/squat_2.png',
        'assets/images/exercises/squat/squat_3.png',
        'assets/images/exercises/squat/squat_4.png',
        'assets/images/exercises/squat/squat_5.png',
        'assets/images/exercises/squat/squat_6.png',
      ]);
    });

    test('lunge exercise has custom iconAssetPath and 6 animation frames', () {
      final lunge = findExerciseById('lunge');
      expect(lunge, isNotNull);
      expect(lunge!.iconAssetPath, 'assets/images/exercises/lunge/lunge_3.png');
      expect(lunge.animationFrames, [
        'assets/images/exercises/lunge/lunge_1.png',
        'assets/images/exercises/lunge/lunge_2.png',
        'assets/images/exercises/lunge/lunge_3.png',
        'assets/images/exercises/lunge/lunge_4.png',
        'assets/images/exercises/lunge/lunge_5.png',
        'assets/images/exercises/lunge/lunge_6.png',
      ]);
    });

    test('jump_squat exercise has custom iconAssetPath and 6 animation frames', () {
      final jumpSquat = findExerciseById('jump_squat');
      expect(jumpSquat, isNotNull);
      expect(jumpSquat!.iconAssetPath, 'assets/images/exercises/jump-squat/jump-squat_3.png');
      expect(jumpSquat.animationFrames, [
        'assets/images/exercises/jump-squat/jump-squat_1.png',
        'assets/images/exercises/jump-squat/jump-squat_2.png',
        'assets/images/exercises/jump-squat/jump-squat_3.png',
        'assets/images/exercises/jump-squat/jump-squat_4.png',
        'assets/images/exercises/jump-squat/jump-squat_5.png',
        'assets/images/exercises/jump-squat/jump-squat_6.png',
      ]);
    });

    test('wall_sit exercise has custom iconAssetPath and 6 animation frames', () {
      final wallSit = findExerciseById('wall_sit');
      expect(wallSit, isNotNull);
      expect(wallSit!.iconAssetPath, 'assets/images/exercises/wallsit/wallsit_3.png');
      expect(wallSit.animationFrames, [
        'assets/images/exercises/wallsit/wallsit_1.png',
        'assets/images/exercises/wallsit/wallsit_2.png',
        'assets/images/exercises/wallsit/wallsit_3.png',
        'assets/images/exercises/wallsit/wallsit_4.png',
        'assets/images/exercises/wallsit/wallsit_5.png',
        'assets/images/exercises/wallsit/wallsit_6.png',
      ]);
    });

    test('plank exercise has custom iconAssetPath and 6 animation frames', () {
      final plank = findExerciseById('plank');
      expect(plank, isNotNull);
      expect(plank!.iconAssetPath, 'assets/images/exercises/plank/plank_2.png');
      expect(plank.animationFrames, [
        'assets/images/exercises/plank/plank_1.png',
        'assets/images/exercises/plank/plank_2.png',
        'assets/images/exercises/plank/plank_3.png',
        'assets/images/exercises/plank/plank_4.png',
        'assets/images/exercises/plank/plank_5.png',
        'assets/images/exercises/plank/plank_6.png',
      ]);
    });

    test('crunch exercise has custom iconAssetPath and 6 animation frames', () {
      final crunch = findExerciseById('crunch');
      expect(crunch, isNotNull);
      expect(crunch!.iconAssetPath, 'assets/images/exercises/crunch/crunch_3.png');
      expect(crunch.animationFrames, [
        'assets/images/exercises/crunch/crunch_1.png',
        'assets/images/exercises/crunch/crunch_2.png',
        'assets/images/exercises/crunch/crunch_3.png',
        'assets/images/exercises/crunch/crunch_4.png',
        'assets/images/exercises/crunch/crunch_5.png',
        'assets/images/exercises/crunch/crunch_6.png',
      ]);
    });

    test('mountain_climber exercise has custom iconAssetPath and 6 animation frames', () {
      final mountainClimber = findExerciseById('mountain_climber');
      expect(mountainClimber, isNotNull);
      expect(mountainClimber!.iconAssetPath,
          'assets/images/exercises/mountain-climber/mountain-climber_6.png');
      expect(mountainClimber.animationFrames, [
        'assets/images/exercises/mountain-climber/mountain-climber_1.png',
        'assets/images/exercises/mountain-climber/mountain-climber_2.png',
        'assets/images/exercises/mountain-climber/mountain-climber_3.png',
        'assets/images/exercises/mountain-climber/mountain-climber_4.png',
        'assets/images/exercises/mountain-climber/mountain-climber_5.png',
        'assets/images/exercises/mountain-climber/mountain-climber_6.png',
      ]);
    });

    test('bicycle_crunch exercise has custom iconAssetPath and 6 animation frames', () {
      final bicycleCrunch = findExerciseById('bicycle_crunch');
      expect(bicycleCrunch, isNotNull);
      expect(bicycleCrunch!.iconAssetPath,
          'assets/images/exercises/bicycle-crunch/bicycle-crunch_5.png');
      expect(bicycleCrunch.animationFrames, [
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_1.png',
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_2.png',
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_3.png',
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_4.png',
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_5.png',
        'assets/images/exercises/bicycle-crunch/bicycle-crunch_6.png',
      ]);
    });

    test('jumping_jack exercise has custom iconAssetPath and 6 animation frames', () {
      final jumpingJack = findExerciseById('jumping_jack');
      expect(jumpingJack, isNotNull);
      expect(jumpingJack!.iconAssetPath,
          'assets/images/exercises/jumping-jack/jumping-jack_2.png');
      expect(jumpingJack.animationFrames, [
        'assets/images/exercises/jumping-jack/jumping-jack_1.png',
        'assets/images/exercises/jumping-jack/jumping-jack_2.png',
        'assets/images/exercises/jumping-jack/jumping-jack_3.png',
        'assets/images/exercises/jumping-jack/jumping-jack_4.png',
        'assets/images/exercises/jumping-jack/jumping-jack_5.png',
        'assets/images/exercises/jumping-jack/jumping-jack_6.png',
      ]);
    });

    test('high_knees exercise has custom iconAssetPath and 6 animation frames', () {
      final highKnees = findExerciseById('high_knees');
      expect(highKnees, isNotNull);
      expect(highKnees!.iconAssetPath,
          'assets/images/exercises/high-knee/high-knee_2.png');
      expect(highKnees.animationFrames, [
        'assets/images/exercises/high-knee/high-knee_1.png',
        'assets/images/exercises/high-knee/high-knee_2.png',
        'assets/images/exercises/high-knee/high-knee_3.png',
        'assets/images/exercises/high-knee/high-knee_4.png',
        'assets/images/exercises/high-knee/high-knee_5.png',
        'assets/images/exercises/high-knee/high-knee_6.png',
      ]);
    });

    test('burpee exercise has custom iconAssetPath and 6 animation frames', () {
      final burpee = findExerciseById('burpee');
      expect(burpee, isNotNull);
      expect(burpee!.iconAssetPath,
          'assets/images/exercises/burpee/burpee_6.png');
      expect(burpee.animationFrames, [
        'assets/images/exercises/burpee/burpee_1.png',
        'assets/images/exercises/burpee/burpee_2.png',
        'assets/images/exercises/burpee/burpee_3.png',
        'assets/images/exercises/burpee/burpee_4.png',
        'assets/images/exercises/burpee/burpee_5.png',
        'assets/images/exercises/burpee/burpee_6.png',
      ]);
    });
  });

  group('Workout Routines data (spec §4.2)', () {
    test(
      'contains all 3 canonical routines with correct duration and exercises',
      () {
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
      },
    );

    test('findRoutineById returns null for unknown id', () {
      expect(findRoutineById('non_existent'), isNull);
    });
  });
}
