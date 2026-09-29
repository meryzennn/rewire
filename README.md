# Rewire

Rewire is an offline-first habit recovery and wellbeing mobile app built with Flutter. It is designed to assist users in overcoming pornography and masturbation addiction (PMO) through a structured three-pillar methodology: **streak tracking**, **ambient meditation**, and **calisthenics/bodyweight training**.

100% offline: all data is stored locally on the device using SQLite and SharedPreferences. No sign-up, no user accounts, no telemetry, and no network connection required.

---

## Key Features

### 1. Streak & Relapse Tracking
- **Real-Time Counter**: Tracks elapsed recovery time in days, hours, minutes, and seconds since the last reset.
- **Relapse Logger**: Log slips with associated triggers, mood states, and reflection notes.
- **Milestone Badges**: Unlocks achievements for 1, 3, 7, 14, 30, 90, 180, and 365 clean days.
- **Brain Recovery Stages (50 Levels)**: Tracks progress from Level 1 (Foggy Brain) to Level 50 (Mastery / Fully Rewired).

### 2. Mind & Ambient Soundscapes
- Six looped ambient tracks: Rain, Waves, Forest, Campfire, Ambient Wave, and White Noise.
- Custom session timers with continuous audio looping.
- Wakelock integration keeps the screen active during sessions.
- Completing sessions awards XP toward brain recovery milestones.

### 3. Bodyweight Workouts
- Structured daily bodyweight circuits with interval and rest timers.
- Step-by-step illustration sliders for all 15 exercises with instant swipe transitions and precached frames.
- Joint safety guardrails that detect high-impact movements and recommend low-impact alternatives for beginners or high BMI profiles.
- Workout history tracking with XP rewards.

### 4. Emergency Urge Reset
- Guided 4-7-8 breathing exercises to de-escalate acute urges.
- Motivational friction prompts to break impulsive behavioral loops.

### 5. Profile & Customization
- **Physical Metrics**: Stores age, height, weight, and calculated BMI locally.
- **Avatar Editor**: Interactive crop, pan, and zoom dialog supporting PNG, JPG, JPEG, and WEBP formats.
- **Localization**: Live interface language switching across English, Indonesian, Spanish, and Japanese.
- **Reminders**: Morning and evening check-in notification scheduler.
- **Data Management**: Local data backup, export, and reset controls.

---

## Architecture & Project Structure

The project follows the Model-View-ViewModel (MVVM) pattern using Provider:

```
lib/
├── core/
│   ├── constants/       # XP tables, badge definitions, brain stage milestones
│   ├── database/        # SQLite helper & migration schemas
│   ├── theme/           # AppColors, AppTypography, AppTheme
│   └── utils/           # XP calculation engines, date/time formatting
├── data/                # Static exercise definitions and asset frame mappings
├── models/              # Immutable data models (Streak, RelapseLog, Quest, Badge, Workout, etc.)
├── repositories/        # SQLite data access layer
├── services/            # Audio player, local notifications, shared preferences
├── viewmodels/          # Reactive state management (Streak, Quest, Meditation, Workout, etc.)
├── screens/             # UI views (Dashboard, Meditation, Workout, SOS, Profile)
├── widgets/             # Reusable UI components & navigation bar
├── app.dart             # GoRouter setup, tab navigation shell, and multi-provider tree
└── main.dart            # Resilient async initialization & app entry point
```

---

## Tech Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: Provider
- **Routing**: GoRouter
- **Local Persistence**: `sqflite` (SQLite), `shared_preferences`, `path_provider`
- **Audio & Media**: `audioplayers`, `image_picker`
- **Visuals & Charts**: `fl_chart`, `lottie`, `google_fonts`
- **Platform Services**: `flutter_local_notifications`, `wakelock_plus`, `timezone`

---

## Download APK

Pre-built release APKs for Android 5.0+ are available on GitHub Releases:

**[Download APK from GitHub Releases](https://github.com/meryzennn/rewire/releases)**

Available packages per release:
- **`app-arm64-v8a-release.apk`** (recommended): optimized for modern Android smartphones (~48 MB).
- **`app-armeabi-v7a-release.apk`**: for older 32-bit Android devices (~46 MB).
- **`app-x86_64-release.apk`**: for x86_64 Android tablets and emulators (~50 MB).

---

## Getting Started

### Prerequisites
- Flutter SDK (3.24+ recommended)
- Android SDK & JDK 17 / 21
- Git

### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/meryzennn/rewire.git
   cd rewire
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run automated tests (276 test cases):
   ```bash
   flutter test
   ```

4. Run the app in debug mode on a connected device/emulator:
   ```bash
   flutter run
   ```

5. Build production release APKs split by architecture:
   ```bash
   flutter build apk --split-per-abi --release
   ```
   The generated APKs will be located at `build/app/outputs/flutter-apk/`.
