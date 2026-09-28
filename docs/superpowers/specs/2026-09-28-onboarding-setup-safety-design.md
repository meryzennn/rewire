# Design Specification: Onboarding Setup Screen, Multilingual Defaults, and Adaptive Workout Safety Engine

- **Date**: 2026-09-28
- **Status**: Approved
- **Target Version**: Rewire v1.1

---

## 1. Overview & Goals

This specification covers four interconnected system enhancements to Rewire:
1. **Multilingual Onboarding & English Default**: Sets default application language to English (`en`) for new installations, with full multilingual support (`en`, `id`, `es`, `ja`) across onboarding and all setup surfaces.
2. **Initial Profile Setup Screen (`/profile-setup`)**: A dedicated onboarding step presented between the onboarding swipe carousel and Home, enabling users to customize their Name, Profile Picture (PFP), Birthday (with birth year and dynamic age calculation), Height (cm), Weight (kg), Live BMI status, Fitness Level Preference (**Beginner**, **Intermediate**, **Expert**), and Language selection. A prominent **Skip** button allows immediate bypass with sensible defaults.
3. **Profile Screen Extensions**: Exposes Birthday and Fitness Level in [`ProfileScreen`](file:///D:/coding/rewire/lib/screens/profile/profile_screen.dart) for ongoing review and editing alongside existing metrics.
4. **Adaptive Workout Safety Engine**: Protects users categorized as **Beginner** or **Obese** ($\text{BMI} \ge 30.0$) against high-impact, spine-straining, or excessive-joint-load exercises (jumping jacks, burpees, jump squats, high knees, deep squats, full pushups, repetitive crunches, rapid mountain climbers, HIIT) through cautionary badges, joint-protection rationale, and safe low-impact alternative exercises (e.g. knee push-ups, wall sits, planks).

---

## 2. Architecture & Data Model

### 2.1 Preference Keys & Schema Extensions
All new user preferences are stored synchronously in [`SharedPreferences`] and surfaced through [`PreferenceService`](file:///D:/coding/rewire/lib/services/preference_service.dart):

```dart
class PrefKeys {
  // Existing keys...
  static const userBirthDate = 'user_birth_date';      // ISO 8601 string: YYYY-MM-DD
  static const userFitnessLevel = 'user_fitness_level'; // 'beginner' | 'intermediate' | 'expert'
}
```

- **Default Language**: Changed from `'id'` to `'en'`:
  ```dart
  String get language => _prefs.getString(PrefKeys.language) ?? 'en';
  ```
- **Birthday & Age Resolution**:
  ```dart
  DateTime? get userBirthDate {
    final str = _prefs.getString(PrefKeys.userBirthDate);
    return str != null ? DateTime.tryParse(str) : null;
  }
  
  int? get userBirthYear => userBirthDate?.year;
  
  int? get userAge {
    final bday = userBirthDate;
    if (bday != null) {
      final now = DateTime.now();
      int age = now.year - bday.year;
      if (now.month < bday.month || (now.month == bday.month && now.day < bday.day)) {
        age--;
      }
      return age;
    }
    return _prefs.getInt(PrefKeys.userAge);
  }
  ```
- **Fitness Level**:
  ```dart
  String get userFitnessLevel => _prefs.getString(PrefKeys.userFitnessLevel) ?? 'beginner';
  Future<void> setUserFitnessLevel(String value) => _writeString(PrefKeys.userFitnessLevel, value);
  ```
- **Reset Sweep**: `PrefKeys.userBirthDate` and `PrefKeys.userFitnessLevel` are added to `PrefKeys.all`.

### 2.2 Health Utilities (`lib/core/utils/health_utils.dart`)
- **BMI Formula**: $\text{BMI} = \frac{\text{weight (kg)}}{(\text{height (m)})^2}$
- **WHO Categories**:
  - `< 18.5`: Underweight
  - `18.5 – 24.9`: Normal
  - `25.0 – 29.9`: Overweight
  - `≥ 30.0`: Obese

---

## 3. User Flow & Routing

```
[ First Launch / Clean Data ]
              │
              ▼
   [ OnboardingScreen ] (Default English, 4-page swipe carousel)
              │
              ├── User finishes carousel OR taps skip in onboarding
              ▼
   [ InitialSetupScreen (`/profile-setup`) ]
              ├── 1. Top Skip Button ─────────────────────────┐
              ├── 2. Live Language Selector (EN, ID, ES, JA)  │
              ├── 3. PFP & Name (Default "Anon")              │
              ├── 4. Birthday DatePicker -> Auto Age & Year   │ (Sets `onboarding_completed: true`)
              ├── 5. Height & Weight -> Live BMI calculation  │
              ├── 6. Fitness Level (Beginner/Interm/Expert)   │
              └── 7. "Continue to App" CTA ───────────────────┼──► [ HomeScreen (`/`) ]
```

### 3.1 Router Configuration in `lib/app.dart`
- New route path: `Routes.profileSetup = '/profile-setup'`.
- Router redirect rule:
  - If `onboarding_completed == false`:
    - Admitted paths: `Routes.onboarding`, `Routes.profileSetup`.
    - Any attempt to reach shell tabs (`/`, `/progress`, `/workout`, etc.) redirects to `Routes.onboarding`.
  - When user completes onboarding swipe carousel, navigate to `context.go(Routes.profileSetup)`.
  - When user taps "Skip" or "Continue" on `InitialSetupScreen`, persist `onboarding_completed: true` and navigate to `context.go(Routes.home)`.

---

## 4. Initial Setup Screen Specification

### 4.1 Component Breakdown
1. **AppBar**:
   - Title: `Personalize Your Journey` (localized)
   - Action Button: TextButton `Skip` (`key: Key('setup-skip-button')`).
2. **Language Selector Card**:
   - Segmented buttons for: English (default), Bahasa Indonesia, Español, 日本語.
   - Calling `preferences.setLanguage(lang)` immediately re-renders the app reactively.
3. **Identity Card**:
   - Circular Avatar with camera overlay (gallery picker, validates PNG, JPG, JPEG, WEBP).
   - Name input with placeholder "Anon".
4. **Birthday Card**:
   - Date picker trigger with calendar icon.
   - Formatted output: Date + Birth Year + Age (e.g. `20 May 1998 (28 years old)`).
5. **Body Metrics Card**:
   - Height (cm) & Weight (kg) numeric text inputs.
   - Real-time BMI pill showing metric value and color-coded status badge.
6. **Fitness Level Selector Card**:
   - 3 interactive selection tiles:
     - **Beginner**: "New to fitness or returning after a long break"
     - **Intermediate**: "Regularly active, comfortable with standard exercises"
     - **Expert**: "Experienced athlete with high endurance & strength"
7. **Bottom Sticky Action**:
   - Full-width button: `Continue to App ✓` (`key: Key('setup-continue-button')`).

---

## 5. Workout Safety & Adaptation Engine

### 5.1 Architecture (`lib/core/utils/workout_safety_utils.dart`)
- **Activation Criteria**: Triggered when `userFitnessLevel == 'beginner'` OR `bmi >= 30.0` (Obese).
- **Contraindicated Exercise Registry**:
  | Category | Exercises | Medical/Biomechanics Rationale | Safe Alternative |
  |---|---|---|---|
  | High-Impact Jumping | `jumping_jack`, `burpee`, `jump_squat`, `high_knees` | Repetitive ground reaction forces transfer extreme multi-bodyweight loads to knee cartilage, ankles, and lumbar spine. | `wall_sit` or `knee_pushup` |
  | Full Bodyweight Load | `pushup`, `diamond_pushup` | Lifting 65-75% of heavy bodyweight risks rotator cuff tears and wrist joint hyperextension. | `knee_pushup` (reduces load to ~50% with stable lever) |
  | Rapid Shoulder/Wrist Shock | `mountain_climber` | High cadence knee drives compromise wrist angle and abruptly elevate heart rate beyond safe threshold. | `plank` (static isometric neutral spine hold) |
  | Repetitive Spinal Flexion | `crunch`, `bicycle_crunch` | Excessive lumbar disc compressive shear forces without metabolic benefit. | `plank` (spine-neutral core engagement) |

### 5.2 UI Integrations
1. **[`ExerciseDetailScreen`](file:///D:/coding/rewire/lib/screens/workout/exercise_detail_screen.dart)**:
   - Displays a prominent amber safety banner when an exercise is contraindicated for the user:
     - Title: `Joint Safety Caution ⚠️`
     - Description: Explains why this movement is contraindicated for beginners or high joint loads.
     - Recommended substitute chip with direct button: `Switch to [Alternative]`.
2. **Start Workout Confirmation Dialog**:
   - If user taps "Start This Exercise" on a contraindicated exercise:
     - Dialog Title: `Joint Safety Notice`
     - Action A (Recommended): `Use Safe Alternative` (switches session to the alternative).
     - Action B (Secondary): `Proceed Anyway` (allows manual override).

---

## 6. Localization (ARB Keys)

The following keys are added to `app_en.arb`, `app_id.arb`, `app_es.arb`, and `app_ja.arb`:
- `setupTitle`: "Personalize Your Journey" / "Personalisasi Profil" / "Personaliza tu viaje" / "プロフィール設定"
- `skip`: "Skip" / "Lewati" / "Saltar" / "スキップ"
- `continueToApp`: "Continue to App" / "Lanjutkan ke Beranda" / "Continuar a la app" / "アプリを開始"
- `languageChoice`: "Language" / "Bahasa" / "Idioma" / "言語"
- `birthdayLabel`: "Birthday" / "Tanggal Lahir" / "Cumpleaños" / "生年月日"
- `birthYearLabel`: "Birth Year" / "Tahun Lahir" / "Año de nacimiento" / "生まれ年"
- `fitnessLevelLabel`: "Fitness Level" / "Tingkat Kebugaran" / "Nivel de condición física" / "フィットネスレベル"
- `beginner`: "Beginner" / "Pemula" / "Principiante" / "初級"
- `beginnerDesc`: "New to fitness or returning after a break" / "Pemula atau baru kembali berolahraga" / "Principiante o volviendo tras una pausa" / "運動初心者または久しぶりの運動"
- `intermediate`: "Intermediate" / "Menengah" / "Intermedio" / "中級"
- `intermediateDesc`: "Active regularly and comfortable with bodyweight exercises" / "Rutin berolahraga dan terbiasa latihan fisik" / "Activo regularmente y acostumbrado a ejercicios con peso corporal" / "定期的に運動し自重トレーニングに慣れている"
- `expert`: "Expert" / "Mahir" / "Experto" / "上級"
- `expertDesc`: "High strength and endurance training routine" / "Daya tahan dan kekuatan fisik tinggi" / "Entrenamiento de alta fuerza y resistencia" / "高い筋力と持久力を持つアスリート"
- `bmiLabel`: "BMI" / "BMI" / "IMC" / "BMI"
- `bmiNormal`: "Normal" / "Normal" / "Normal" / "普通体重"
- `bmiOverweight`: "Overweight" / "Kelebihan Berat Badan" / "Sobrepeso" / "肥満（1度）"
- `bmiObese`: "Obese" / "Obesitas" / "Obesidad" / "肥満（2度以上）"
- `jointSafetyWarningTitle`: "Joint Safety Caution ⚠️" / "Perhatian Beban Sendi ⚠️" / "Atención: Cuidado Articular ⚠️" / "関節の保護注意 ⚠️"
- `jointSafetyWarningDesc`: "This movement puts high impact or full bodyweight pressure on knee, ankle, or shoulder joints. Beginners or individuals with elevated body mass are advised to use low-impact alternatives."
- `useSafeAlternative`: "Use Safe Alternative" / "Gunakan Alternatif Aman" / "Usar alternativa segura" / "安全な代替種目を使用"
- `proceedAnyway`: "Proceed Anyway" / "Tetap Lanjutkan" / "Continuar de todos modos" / "そのまま続行"

---

## 7. Testing & Verification Plan

1. **Unit Tests**:
   - `test/core/health_utils_test.dart`: Formula validation, boundary testing (BMI values 18.4, 18.5, 24.9, 25.0, 29.9, 30.0).
   - `test/core/workout_safety_utils_test.dart`: Detection tests for contraindicated exercises across different fitness levels and BMI categories; alternative mapping validation.
   - `test/services/preference_service_test.dart`: Tests for `userBirthDate`, `userBirthYear`, `userAge`, `userFitnessLevel`, and default `'en'` language.
2. **Widget Tests**:
   - `test/screens/onboarding/initial_setup_screen_test.dart`: Validates skip button navigation, form inputs persistence, language switching, and BMI live updates.
   - `test/screens/workout/exercise_detail_safety_test.dart`: Tests safety warning banner appearance for beginner/obese profiles and alternative switch dialog.
   - `test/screens/profile/profile_screen_test.dart`: Tests rendering and editing of birthday and fitness level in profile bottom sheet.
3. **Regression Tests**:
   - Run `rtk flutter test` across the full suite (208+ tests) to guarantee zero regressions.
