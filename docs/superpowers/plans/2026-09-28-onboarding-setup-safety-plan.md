# Onboarding Setup Screen, Multilingual Defaults, and Adaptive Workout Safety Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a post-onboarding profile setup screen (`/profile-setup`), set English as the default application language with live 4-language switching, enable birthday/age & fitness level persistence, and integrate an adaptive joint-safety engine protecting beginners and obese users against high-impact exercises.

**Architecture:** Extend `PreferenceService` with birthday, dynamic age calculation, and fitness level (`beginner`, `intermediate`, `expert`). Build a modular `HealthUtils` (BMI) and `WorkoutSafetyUtils` (contraindicated movements, joint-load warnings, and safe alternatives). Wire a new `InitialSetupScreen` between onboarding and home, update `ProfileScreen` with birthday and fitness level editing, and display safety banners & alternative confirmation dialogs in `ExerciseDetailScreen`.

**Tech Stack:** Flutter, GoRouter, SharedPreferences, Provider, Flutter Localizations (ARB), ImagePicker.

**Spec:** [`docs/superpowers/specs/2026-09-28-onboarding-setup-safety-design.md`](file:///D:/coding/rewire/docs/superpowers/specs/2026-09-28-onboarding-setup-safety-design.md)

## Global Constraints
- Always prefix terminal commands with `rtk` (e.g. `rtk flutter test`, `rtk git status`).
- **NEVER** run `flutter build apk`.
- Follow Ponytail principles: shortest working diff, root cause fix, no unrequested abstractions.
- All newly added user-facing text must support all 4 locales (`en`, `id`, `es`, `ja`).
- Fallback strings in widget tests (`l10n?.key ?? '...'`) must match test fixture expectations.

## Review Focus
1. User taps "Skip" on the setup screen: should write `onboarding_completed: true` with default values (`Anon`, `'en'`, `'beginner'`) and route cleanly to `/`.
2. Live language switching on `InitialSetupScreen`: choosing Spanish, Japanese, Indonesian, or English must immediately update the entire screen's copy without requiring app restart.
3. Live BMI Calculation: typing height (e.g. 170 cm) and weight (e.g. 95 kg) dynamically updates the BMI indicator to `32.9 (Obese)` with caution badge.
4. Birthday and Age: choosing a birth date computes dynamic age accurately; leap years and month/day boundaries calculated without drifting.
5. Safety Warning in Exercise Detail: user with `beginner` level or $\text{BMI} \ge 30.0$ viewing a high-impact exercise (like `burpee`, `jumping_jack`, `pushup`) sees the joint safety caution banner and is offered a safe alternative (like `wall_sit`, `knee_pushup`, `plank`).

---

### Task 1: Health & Workout Safety Utilities (`health_utils.dart` & `workout_safety_utils.dart`)

**Files:**
- Create: `lib/core/utils/health_utils.dart`
- Create: `lib/core/utils/workout_safety_utils.dart`
- Test: `test/core/health_utils_test.dart`
- Test: `test/core/workout_safety_utils_test.dart`

**Interfaces:**
- Produces:
  - `double? calculateBmi(double? heightCm, double? weightKg)`
  - `BmiCategory getBmiCategory(double? bmi)`
  - `bool isExerciseContraindicated(String exerciseId, {required String fitnessLevel, required double? bmi})`
  - `String? getSafeAlternativeExerciseId(String exerciseId)`
  - `(String, String) getLocalizedSafetyWarning(String exerciseId, String? langCode)`

- [x] **Step 1: Write the failing tests for HealthUtils and WorkoutSafetyUtils**

```dart
// test/core/health_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/health_utils.dart';

void main() {
  test('calculateBmi returns null when inputs are invalid or null', () {
    expect(calculateBmi(null, 70), isNull);
    expect(calculateBmi(170, null), isNull);
    expect(calculateBmi(0, 70), isNull);
    expect(calculateBmi(170, 0), isNull);
  });

  test('calculateBmi calculates metric BMI accurately', () {
    // 70 kg, 175 cm -> 70 / (1.75^2) = 22.86
    final bmi = calculateBmi(175, 70);
    expect(bmi, isNotNull);
    expect((bmi! * 10).round() / 10, 22.9);
  });

  test('getBmiCategory categorizes WHO ranges correctly', () {
    expect(getBmiCategory(18.4), BmiCategory.underweight);
    expect(getBmiCategory(18.5), BmiCategory.normal);
    expect(getBmiCategory(24.9), BmiCategory.normal);
    expect(getBmiCategory(25.0), BmiCategory.overweight);
    expect(getBmiCategory(29.9), BmiCategory.overweight);
    expect(getBmiCategory(30.0), BmiCategory.obese);
    expect(getBmiCategory(35.0), BmiCategory.obese);
  });
}
```

```dart
// test/core/workout_safety_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/workout_safety_utils.dart';

void main() {
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
    // Contraindicated for obese user even if intermediate
    expect(
      isExerciseContraindicated('jumping_jack', fitnessLevel: 'intermediate', bmi: 31.0),
      isTrue,
    );
    // Safe for normal BMI intermediate/expert
    expect(
      isExerciseContraindicated('jumping_jack', fitnessLevel: 'intermediate', bmi: 22.0),
      isFalse,
    );
    // Knee pushup and wall sit are safe for everyone
    expect(
      isExerciseContraindicated('knee_pushup', fitnessLevel: 'beginner', bmi: 35.0),
      isFalse,
    );
    expect(
      isExerciseContraindicated('wall_sit', fitnessLevel: 'beginner', bmi: 35.0),
      isFalse,
    );
  });

  test('provides appropriate safe alternative exercises', () {
    expect(getSafeAlternativeExerciseId('pushup'), 'knee_pushup');
    expect(getSafeAlternativeExerciseId('diamond_pushup'), 'knee_pushup');
    expect(getSafeAlternativeExerciseId('jumping_jack'), 'wall_sit');
    expect(getSafeAlternativeExerciseId('burpee'), 'wall_sit');
    expect(getSafeAlternativeExerciseId('mountain_climber'), 'plank');
    expect(getSafeAlternativeExerciseId('crunch'), 'plank');
  });
}
```

- [x] **Step 2: Run test to verify it fails**

Run: `rtk flutter test test/core/health_utils_test.dart test/core/workout_safety_utils_test.dart`
Expected: FAIL (files not found)

- [x] **Step 3: Implement `health_utils.dart` and `workout_safety_utils.dart`**

Implement BMI calculations, `BmiCategory` enum, contraindication checks, and localized warning messages.

- [x] **Step 4: Run test to verify it passes**

Run: `rtk flutter test test/core/health_utils_test.dart test/core/workout_safety_utils_test.dart`
Expected: PASS

- [x] **Step 5: Commit**

```bash
rtk git add lib/core/utils/health_utils.dart lib/core/utils/workout_safety_utils.dart test/core/
rtk git commit -m "feat(utils): add health metrics and workout safety utilities"
```

---

### Task 2: Preference Keys, Schema & Default English Language

**Files:**
- Modify: `lib/services/preference_service.dart`
- Modify: `test/services/preference_service_test.dart`

**Interfaces:**
- Consumes: `PrefKeys`, `SharedPreferences`
- Produces:
  - `String get language => _prefs.getString(PrefKeys.language) ?? 'en'`
  - `DateTime? get userBirthDate`
  - `int? get userBirthYear`
  - `int? get userAge` (dynamically calculated from `userBirthDate` if present)
  - `Future<void> setUserBirthDate(DateTime? date)`
  - `String get userFitnessLevel => _prefs.getString(PrefKeys.userFitnessLevel) ?? 'beginner'`
  - `Future<void> setUserFitnessLevel(String level)`

- [x] **Step 1: Write test assertions in `test/services/preference_service_test.dart`**

Add tests for:
1. `language` defaults to `'en'`.
2. `userBirthDate` stores date, resolves `userBirthYear` and calculates `userAge`.
3. `userFitnessLevel` defaults to `'beginner'` and persists values (`'intermediate'`, `'expert'`).
4. `resetAll()` clears `userBirthDate` and `userFitnessLevel`.

- [x] **Step 2: Run test to verify it fails**

Run: `rtk flutter test test/services/preference_service_test.dart`
Expected: FAIL

- [x] **Step 3: Implement preference additions in `lib/services/preference_service.dart`**

Update `PrefKeys`, default language, birthDate and fitnessLevel getters/setters, and `all` array.

- [x] **Step 4: Run test to verify it passes**

Run: `rtk flutter test test/services/preference_service_test.dart`
Expected: PASS

- [x] **Step 5: Commit**

```bash
rtk git add lib/services/preference_service.dart test/services/preference_service_test.dart
rtk git commit -m "feat(prefs): update language default to english and add birthday and fitness level preferences"
```

---

### Task 3: Multilingual ARB Keys (EN, ID, ES, JA)

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_id.arb`
- Modify: `lib/l10n/app_es.arb`
- Modify: `lib/l10n/app_ja.arb`

- [x] **Step 1: Add setup, health, and joint safety keys to all 4 ARB files**

Keys:
- `setupTitle`, `skip`, `continueToApp`, `languageChoice`
- `birthdayLabel`, `birthYearLabel`, `yearsOldLabel`
- `fitnessLevelLabel`, `beginner`, `beginnerDesc`, `intermediate`, `intermediateDesc`, `expert`, `expertDesc`
- `bmiLabel`, `bmiUnderweight`, `bmiNormal`, `bmiOverweight`, `bmiObese`
- `jointSafetyWarningTitle`, `jointSafetyWarningDesc`, `useSafeAlternative`, `proceedAnyway`, `recommendedAlternativeLabel`

- [x] **Step 2: Run `rtk flutter gen-l10n`**

Run: `rtk flutter gen-l10n`
Expected: Generation succeeds with 0 errors.

- [x] **Step 3: Verify with flutter test**

Run: `rtk flutter test`
Expected: PASS

- [x] **Step 4: Commit**

```bash
rtk git add lib/l10n/
rtk git commit -m "feat(l10n): add localization keys for setup, health metrics, and workout safety"
```

---

### Task 4: Initial Setup Screen (`InitialSetupScreen`) & Navigation Routing

**Files:**
- Create: `lib/screens/onboarding/initial_setup_screen.dart`
- Modify: `lib/app.dart`
- Modify: `lib/screens/onboarding/onboarding_screen.dart`
- Test: `test/screens/onboarding/initial_setup_screen_test.dart`

**Interfaces:**
- Consumes: `PreferenceService`, `Routes`, `HealthUtils`
- Produces: `InitialSetupScreen(preferences: ...)` accessible at `Routes.profileSetup = '/profile-setup'`

- [x] **Step 1: Write widget test for `InitialSetupScreen`**

```dart
// test/screens/onboarding/initial_setup_screen_test.dart
// Tests:
// 1. Tapping Skip sets onboardingCompleted: true and triggers navigation.
// 2. Language chips switch language reactively.
// 3. Form inputs (name, birthday, height, weight, fitness level) persist to preferences.
// 4. BMI pill updates live when height and weight are typed.
```

- [x] **Step 2: Run test to verify it fails**

Run: `rtk flutter test test/screens/onboarding/initial_setup_screen_test.dart`
Expected: FAIL (screen not implemented yet)

- [x] **Step 3: Implement `InitialSetupScreen`**

Create `InitialSetupScreen` with:
- Top bar with `Skip` TextButton.
- Language selector chips (English, Indonesian, Spanish, Japanese) calling `preferences.setLanguage`.
- Circular PFP avatar with camera icon and image picker.
- Name text field with hint and default "Anon".
- Birthday date picker tile showing date, birth year, and computed age.
- Height and Weight inputs with live BMI calculator and color-coded status badge.
- Fitness Level 3-card selector (Beginner, Intermediate, Expert).
- Bottom sticky `Continue to App ✓` button.

- [x] **Step 4: Wire `Routes.profileSetup` in `lib/app.dart` and update `OnboardingScreen`**

In `lib/app.dart`:
- Add `static const String profileSetup = '/profile-setup';`
- Register `GoRoute(path: Routes.profileSetup, ...)`
- Update router redirect logic to permit `Routes.profileSetup` when `onboarding_completed == false`.
- In `OnboardingScreen`, change completion/skip destination from `Routes.home` to `Routes.profileSetup`.

- [x] **Step 5: Run test to verify it passes**

Run: `rtk flutter test test/screens/onboarding/initial_setup_screen_test.dart`
Expected: PASS

- [x] **Step 6: Commit**

```bash
rtk git add lib/screens/onboarding/ lib/app.dart test/screens/onboarding/
rtk git commit -m "feat(onboarding): add initial setup screen and wire route gate"
```

---

### Task 5: Profile Screen Integration (Birthday, Fitness Level, BMI)

**Files:**
- Modify: `lib/screens/profile/profile_screen.dart`
- Modify: `test/screens/profile/profile_screen_test.dart` (or create if not present)

**Interfaces:**
- Consumes: `PreferenceService`, `HealthUtils`
- Produces: Updated User Info card and Edit Profile modal with Birthday and Fitness Level fields.

- [x] **Step 1: Write test for Birthday and Fitness Level in Profile Screen**

Test that Birthday, dynamic age, Fitness Level, and BMI status appear in `ProfileScreen` and can be edited via the edit profile bottom sheet.

- [x] **Step 2: Run test to verify it fails**

Run: `rtk flutter test test/screens/profile/profile_screen_test.dart`
Expected: FAIL

- [x] **Step 3: Update `ProfileScreen`**

- Add Birthday tile to profile stats card.
- Add Fitness Level chip next to level/XP.
- Add Birthday DatePicker and Fitness Level selector in `_showEditProfileDialog()`.
- Save selections to `PreferenceService`.

- [x] **Step 4: Run test to verify it passes**

Run: `rtk flutter test test/screens/profile/profile_screen_test.dart`
Expected: PASS

- [x] **Step 5: Commit**

```bash
rtk git add lib/screens/profile/profile_screen.dart test/screens/profile/
rtk git commit -m "feat(profile): display and edit birthday and fitness level in profile"
```

---

### Task 6: Workout Safety UI in `ExerciseDetailScreen`

**Files:**
- Modify: `lib/screens/workout/exercise_detail_screen.dart`
- Test: `test/screens/workout/exercise_detail_safety_test.dart`

**Interfaces:**
- Consumes: `PreferenceService`, `WorkoutSafetyUtils`, `HealthUtils`
- Produces: Amber joint-safety warning banner and alternative switch confirmation dialog on start.

- [x] **Step 1: Write test for safety banner and dialog in `ExerciseDetailScreen`**

```dart
// test/screens/workout/exercise_detail_safety_test.dart
// Tests:
// 1. When user has beginner fitness level or BMI >= 30, viewing pushup or jumping_jack displays Joint Safety Caution banner.
// 2. Safe alternative exercise chip is displayed (e.g. Knee Push-up or Wall Sit).
// 3. Tapping 'Mulai Latihan Ini' shows confirmation dialog with 'Gunakan Alternatif Aman' and 'Tetap Lanjutkan'.
```

- [x] **Step 2: Run test to verify it fails**

Run: `rtk flutter test test/screens/workout/exercise_detail_safety_test.dart`
Expected: FAIL

- [x] **Step 3: Implement safety UI in `ExerciseDetailScreen`**

- Read user's fitness level and calculate BMI from `PreferenceService`.
- If `isExerciseContraindicated`, show `_buildJointSafetyBanner(...)`.
- When tapping start button, if contraindicated, display `showDialog` with option to start safe alternative or proceed.

- [x] **Step 4: Run test to verify it passes**

Run: `rtk flutter test test/screens/workout/exercise_detail_safety_test.dart`
Expected: PASS

- [x] **Step 5: Commit**

```bash
rtk git add lib/screens/workout/exercise_detail_screen.dart test/screens/workout/exercise_detail_safety_test.dart
rtk git commit -m "feat(workout): integrate joint safety caution banner and alternative dialog in exercise detail"
```

---

### Task 7: Full Test Suite Verification

**Files:**
- All modified and existing test files.

- [x] **Step 1: Run full test suite with `rtk flutter test`**

Run: `rtk flutter test`
Expected: All 208+ existing tests and new tests PASS.

- [x] **Step 2: Push changes to git origin**

```bash
rtk git push origin main
```
