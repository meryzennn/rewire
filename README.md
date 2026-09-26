# Rewire

Aplikasi Android gamifikasi pemulihan berbasis Flutter. Membantu pengguna berhenti dari kebiasaan PMO melalui tiga pilar: streak tracking, meditasi audio ambient, dan latihan tubuh sendiri.

## Status

Sedang dikembangkan — Task 1-2 selesai dari 14 task.

| Task | Deskripsi | Status |
|------|-----------|--------|
| 1 | Scaffold, dependencies, tema | ✅ |
| 2 | XP, level, stage, utilitas tanggal | ✅ |
| 3–14 | Database, repositories, screens, dll. | ⏳ |

## Tech Stack

- Flutter 3.47+ / Dart 3.13+
- Provider + GoRouter
- SQLite (sqflite)
- SharedPreferences
- audioplayers, flutter_local_notifications, fl_chart, lottie

## Arsitektur

Offline-first, seluruh data lokal. Tidak ada backend, HTTP, atau Firebase.

```
lib/
├── core/
│   ├── constants/   # xp_table.dart
│   ├── theme/       # AppColors, AppTypography, AppTheme
│   └── utils/       # xp_utils, date_utils
└── app.dart / main.dart
```

## Jalankan

```bash
flutter pub get
flutter test
flutter run
```

## Desain

Lihat [`DESIGN.md`](DESIGN.md) dan [`docs/UI.md`](docs/UI.md).
