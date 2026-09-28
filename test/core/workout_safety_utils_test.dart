import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/workout_safety_utils.dart';

void main() {
  group('isExerciseContraindicated', () {
    test('flags high impact exercises for beginner or obese users', () {
      // High impact jumps contraindicated for beginner
      expect(
        isExerciseContraindicated('jumping_jack', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('burpee', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('jump_squat', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('high_knees', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );

      // Heavy bodyweight pushups and core contraindicated for beginner
      expect(
        isExerciseContraindicated('pushup', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('diamond_pushup', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('mountain_climber', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('crunch', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('bicycle_crunch', fitnessLevel: 'beginner', bmi: 22.0),
        isTrue,
      );

      // Contraindicated for obese user even if intermediate or expert
      expect(
        isExerciseContraindicated('jumping_jack', fitnessLevel: 'intermediate', bmi: 31.0),
        isTrue,
      );
      expect(
        isExerciseContraindicated('pushup', fitnessLevel: 'expert', bmi: 30.0),
        isTrue,
      );

      // Safe for normal BMI intermediate/expert
      expect(
        isExerciseContraindicated('jumping_jack', fitnessLevel: 'intermediate', bmi: 22.0),
        isFalse,
      );
      expect(
        isExerciseContraindicated('pushup', fitnessLevel: 'expert', bmi: 24.5),
        isFalse,
      );

      // Low impact exercises are safe for everyone (beginners & obese)
      expect(
        isExerciseContraindicated('knee_pushup', fitnessLevel: 'beginner', bmi: 35.0),
        isFalse,
      );
      expect(
        isExerciseContraindicated('wall_sit', fitnessLevel: 'beginner', bmi: 35.0),
        isFalse,
      );
      expect(
        isExerciseContraindicated('plank', fitnessLevel: 'beginner', bmi: 35.0),
        isFalse,
      );
      expect(
        isExerciseContraindicated('squat', fitnessLevel: 'beginner', bmi: 35.0),
        isFalse,
      );
      expect(
        isExerciseContraindicated('lunge', fitnessLevel: 'beginner', bmi: 35.0),
        isFalse,
      );
    });

    test('handles case-insensitivity and null bmi', () {
      expect(
        isExerciseContraindicated('jumping_jack', fitnessLevel: 'Beginner', bmi: null),
        isTrue,
      );
      expect(
        isExerciseContraindicated('jumping_jack', fitnessLevel: 'Expert', bmi: null),
        isFalse,
      );
    });
  });

  group('getSafeAlternativeExerciseId', () {
    test('provides appropriate safe alternative exercises', () {
      expect(getSafeAlternativeExerciseId('pushup'), 'knee_pushup');
      expect(getSafeAlternativeExerciseId('diamond_pushup'), 'knee_pushup');
      expect(getSafeAlternativeExerciseId('jumping_jack'), 'wall_sit');
      expect(getSafeAlternativeExerciseId('burpee'), 'wall_sit');
      expect(getSafeAlternativeExerciseId('jump_squat'), 'wall_sit');
      expect(getSafeAlternativeExerciseId('high_knees'), 'wall_sit');
      expect(getSafeAlternativeExerciseId('mountain_climber'), 'plank');
      expect(getSafeAlternativeExerciseId('crunch'), 'plank');
      expect(getSafeAlternativeExerciseId('bicycle_crunch'), 'plank');
    });

    test('returns null for exercises without alternatives or already safe', () {
      expect(getSafeAlternativeExerciseId('knee_pushup'), isNull);
      expect(getSafeAlternativeExerciseId('wall_sit'), isNull);
      expect(getSafeAlternativeExerciseId('plank'), isNull);
      expect(getSafeAlternativeExerciseId('squat'), isNull);
      expect(getSafeAlternativeExerciseId('non_existent'), isNull);
    });
  });

  group('getLocalizedSafetyWarning', () {
    test('returns localized title and description for supported languages', () {
      final (enTitle, enDesc) = getLocalizedSafetyWarning('jumping_jack', 'en');
      expect(enTitle, 'Joint Safety Caution ⚠️');
      expect(enDesc, contains('Repetitive ground reaction forces'));

      final (idTitle, idDesc) = getLocalizedSafetyWarning('jumping_jack', 'id');
      expect(idTitle, 'Perhatian Beban Sendi ⚠️');
      expect(idDesc, contains('beban kejut berulang'));

      final (esTitle, esDesc) = getLocalizedSafetyWarning('pushup', 'es');
      expect(esTitle, 'Atención: Cuidado Articular ⚠️');
      expect(esDesc, contains('peso corporal'));

      final (jaTitle, jaDesc) = getLocalizedSafetyWarning('mountain_climber', 'ja');
      expect(jaTitle, '関節の保護注意 ⚠️');
      expect(jaDesc, contains('手首に負担'));
    });

    test('falls back gracefully on unknown exercise or null lang', () {
      final (fallbackTitle, fallbackDesc) = getLocalizedSafetyWarning('custom_exercise', null);
      expect(fallbackTitle, 'Joint Safety Caution ⚠️');
      expect(fallbackDesc, isNotEmpty);
    });
  });
}
