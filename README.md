# Rewire

A gamified Android recovery app built with Flutter. Helps users quit PMO through three pillars: streak tracking, ambient audio meditation, and bodyweight exercise.

## Status

In development — Tasks 1–2 of 14 complete.

| Task | Description | Status |
|------|-------------|--------|
| 1 | Scaffold, dependencies, theme | ✅ |
| 2 | XP, levels, brain stages, date utilities | ✅ |
| 3–14 | Database, repositories, screens, etc. | ⏳ |

## Tech Stack

- Flutter 3.47+ / Dart 3.13+
- Provider + GoRouter
- SQLite (sqflite)
- SharedPreferences
- audioplayers, flutter_local_notifications, fl_chart, lottie

## Architecture

Offline-first, all data stored locally. No backend, HTTP, or Firebase.

```
lib/
├── core/
│   ├── constants/   # xp_table.dart
│   ├── theme/       # AppColors, AppTypography, AppTheme
│   └── utils/       # xp_utils, date_utils
└── app.dart / main.dart
```

## Run

```bash
flutter pub get
flutter test
flutter run
```

## Design

See [`DESIGN.md`](DESIGN.md) and [`docs/UI.md`](docs/UI.md).
