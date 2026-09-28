import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/health_utils.dart';

void main() {
  group('calculateBmi', () {
    test('returns null when inputs are invalid or null', () {
      expect(calculateBmi(null, 70), isNull);
      expect(calculateBmi(170, null), isNull);
      expect(calculateBmi(0, 70), isNull);
      expect(calculateBmi(170, 0), isNull);
      expect(calculateBmi(-170, 70), isNull);
      expect(calculateBmi(170, -70), isNull);
    });

    test('calculates metric BMI accurately', () {
      // 70 kg, 175 cm -> 70 / (1.75^2) = 22.86
      final bmi = calculateBmi(175, 70);
      expect(bmi, isNotNull);
      expect((bmi! * 10).round() / 10, 22.9);

      // 95 kg, 170 cm -> 95 / (1.70^2) = 32.87
      final bmiObese = calculateBmi(170, 95);
      expect(bmiObese, isNotNull);
      expect((bmiObese! * 10).round() / 10, 32.9);
    });
  });

  group('getBmiCategory', () {
    test('categorizes WHO ranges correctly', () {
      expect(getBmiCategory(18.4), BmiCategory.underweight);
      expect(getBmiCategory(18.5), BmiCategory.normal);
      expect(getBmiCategory(24.9), BmiCategory.normal);
      expect(getBmiCategory(25.0), BmiCategory.overweight);
      expect(getBmiCategory(29.9), BmiCategory.overweight);
      expect(getBmiCategory(30.0), BmiCategory.obese);
      expect(getBmiCategory(35.0), BmiCategory.obese);
    });

    test('handles null and non-positive bmi gracefully', () {
      expect(getBmiCategory(null), BmiCategory.normal);
      expect(getBmiCategory(0), BmiCategory.normal);
      expect(getBmiCategory(-5.0), BmiCategory.normal);
    });
  });
}
