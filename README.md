# Rewire

Rewire is an offline-first habit recovery and wellbeing mobile app built with Flutter. It is designed to assist users in overcoming pornography and masturbation addiction (PMO) through a structured three-pillar methodology: **streak tracking**, **ambient meditation**, and **calisthenics/bodyweight training**.

100% offline — all data is stored locally on the device using SQLite and SharedPreferences. No sign-up, no user accounts, no telemetries, and no network connection required.

---

## Key Features

### 1. Pillar 1: Streak & Relapse Tracking
- **Real-Time Counter**: Tracks elapsed recovery time in days, hours, minutes, and seconds since the last reset.
- **Relapse Logger**: Log slips with associated triggers, mood states, and reflection notes.
- **Milestone Badges**: Automatically unlocks achievements for 1, 3, 7, 14, 30, 90, 180, and 365 clean days.
- **Brain Recovery Stages (50 Levels)**: Visual representation of neuroplastic recovery from Level 1 (Foggy Brain) to Level 50 (Mastery / Fully Rewired).

### 2. Pillar 2: Mind (Ambient Meditation)
- Ambient sound generator (rain, white noise, nature sounds) with custom session timers.
- Wakelock integration prevents the screen from turning off during mindfulness sessions.
- Grants XP upon completing meditation sessions.

### 3. Pillar 3: Body (Calisthenics Workouts)
- Structured daily bodyweight exercise circuits with interval and rest timers.
- Workout history tracking with XP reward integration.

### 4. Emergency SOS / Panic Mode
- Instant access to guided 4-7-8 breathing exercises to de-escalate acute urges.
- Motivational friction prompts to break impulsive behavioral loops.

### 5. Profile & Settings
- **Physical Metrics**: Stores name, age, height, and weight locally.
- **Avatar Upload**: Custom profile photo picker supporting `.png`, `.jpg`, `.jpeg`, and `.webp` formats.
- **Reminders**: Morning and evening check-in notification scheduler.
- **Data Management**: Local data backup, export, and reset controls.

---

## Architecture & Project Structure

The project follows the **Model-View-ViewModel (MVVM)** pattern using `Provider`:

```
lib/
├── core/
│   ├── constants/       # XP tables, badge definitions, brain stage milestones
│   ├── database/        # SQLite helper & migration schemas
│   ├── theme/           # AppColors, AppTypography, AppTheme
│   └── utils/           # XP calculation engines, date/time formatting
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

Pre-built release APKs for Android (Android 5.0+) are available directly on GitHub:

👉 **[Download APK from GitHub Releases](https://github.com/meryzennn/rewire/releases)**

Download `app-release.apk` from the latest release.

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

3. Run automated tests (200 test cases):
   ```bash
   flutter test
   ```

4. Run the app in debug mode on a connected device/emulator:
   ```bash
   flutter run
   ```

5. Build the production release APK:
   ```bash
   flutter build apk --release
   ```
   The generated APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.
