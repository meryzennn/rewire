/// WHO standard BMI categories and calculation helpers.
library;

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese,
}

/// Calculates Body Mass Index (BMI) using metric units:
/// BMI = weight (kg) / (height (m))^2.
///
/// Returns `null` if either [heightCm] or [weightKg] is `null` or non-positive.
double? calculateBmi(double? heightCm, double? weightKg) {
  if (heightCm == null || weightKg == null) return null;
  if (heightCm <= 0 || weightKg <= 0) return null;
  final heightM = heightCm / 100.0;
  return weightKg / (heightM * heightM);
}

/// Maps a [bmi] value to its corresponding WHO standard [BmiCategory].
///
/// - Underweight: < 18.5
/// - Normal: 18.5 - 24.9
/// - Overweight: 25.0 - 29.9
/// - Obese: >= 30.0
///
/// Returns [BmiCategory.normal] if [bmi] is `null` or non-positive as a safe default.
BmiCategory getBmiCategory(double? bmi) {
  if (bmi == null || bmi <= 0) return BmiCategory.normal;
  if (bmi < 18.5) return BmiCategory.underweight;
  if (bmi < 25.0) return BmiCategory.normal;
  if (bmi < 30.0) return BmiCategory.overweight;
  return BmiCategory.obese;
}
