# Rewire

Rewire adalah aplikasi recovery & pembentukan kebiasaan offline-first berbasis Flutter. Dirancang untuk membantu pengguna pulih dari kecanduan pornografi/masturbasi (PMO) secara terstruktur melalui pendekatan 3 pilar: pelacakan streak, meditasi audio ambient, dan latihan fisik kalistenik/bodyweight.

100% offline — semua data tersimpan secara lokal di perangkat menggunakan SQLite dan SharedPreferences. Tanpa login, tanpa analitik/telemetri, dan tanpa koneksi internet.

---

## Fitur Utama (3 Pilar + Gamifikasi)

### 1. Pilar 1: Pelacakan Streak & Relapse
- **Real-Time Counter**: Menghitung hari, jam, menit, dan detik sejak reset terakhir.
- **Relapse Logger**: Pencatatan riwayat kambuh lengkap dengan pencatatan pemicu (trigger), mood, dan catatan refleksi.
- **Milestone Badges**: Pencapaian otomatis pada hari ke-1, 3, 7, 14, 30, 90, 180, dan 365.
- **Brain Stage (50 Level)**: Visualisasi progres pemulihan otak bertahap dari Level 1 (Foggy Brain) hingga Level 50 (Mastery / Rewired).

### 2. Pilar 2: Mind (Meditasi & Audio Ambient)
- Pemutar audio ambient (hujan, derau putih, suara alam) dengan pengatur waktu (timer).
- Integrasi *wakelock* untuk menjaga layar tetap aktif saat sesi meditasi berlangsung.
- Memberikan hadiah XP setelah menyelesaikan sesi.

### 3. Pilar 3: Body (Latihan Fisik Kalistenik)
- Sirkuit latihan bodyweight harian terstruktur dengan interval timer dan istirahat.
- Riwayat log latihan dan integrasi XP ke sistem level utama.

### 4. Tombol Darurat (SOS / Panic Mode)
- Akses instan ke latihan pernapasan terpandu (4-7-8 breathing) saat dorongan/urge muncul.
- Kutipan pengingat komitmen untuk memutus rantai impulsif.

### 5. Profil & Pengaturan
- **Data Fisik**: Nama, usia, tinggi badan, dan berat badan tersimpan aman di perangkat.
- **Foto Profil**: Dukungan upload gambar foto profil (.png, .jpg, .jpeg, .webp).
- **Notifikasi Harian**: Pengingat check-in pagi dan malam hari.
- **Backup & Reset**: Opsi reset data dan ekspor/impor lokal.

---

## Arsitektur & Struktur Proyek

Aplikasi ini menggunakan pola arsitektur **MVVM (Model-View-ViewModel)** dengan `Provider`:

```
lib/
├── core/
│   ├── constants/       # XP table, badge definitions, brain stages
│   ├── database/        # SQLite helper & skema migrasi
│   ├── theme/           # AppColors, AppTypography, AppTheme
│   └── utils/           # Perhitungan XP, format tanggal & waktu
├── models/              # Model data (Streak, RelapseLog, Quest, Badge, Workout, dsb.)
├── repositories/        # Abstraksi data layer ke SQLite
├── services/            # Audio, notifikasi lokal, dan preferensi
├── viewmodels/          # State management (Streak, Quest, Meditation, Workout, dsb.)
├── screens/             # Halaman UI (Dashboard, Meditation, Workout, SOS, Profile)
├── widgets/             # Reusable UI components & bottom navigation bar
├── app.dart             # Konfigurasi router, navigasi tab, dan multi-provider
└── main.dart            # Entry point & inisialisasi async yang tangguh
```

---

## Tech Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: Provider
- **Routing**: GoRouter
- **Penyimpanan Lokal**: `sqflite` (SQLite), `shared_preferences`, `path_provider`
- **Audio & Media**: `audioplayers`, `image_picker`
- **Visuals & Charts**: `fl_chart`, `lottie`, `google_fonts`
- **System**: `flutter_local_notifications`, `wakelock_plus`, `timezone`

---

## Download APK

File APK rilis terbaru siap pasang di perangkat Android (Android 5.0+):

👉 **[Unduh APK di GitHub Releases](https://github.com/meryzennn/rewire/releases)**

Pilih file `app-release.apk` dari rilis terbaru.

---

## Menjalankan dari Source Code

### Prasyarat
- Flutter SDK (3.24+ disarankan)
- Android SDK & JDK 17/21
- Git

### Langkah Instalasi

1. Clone repositori:
   ```bash
   git clone https://github.com/meryzennn/rewire.git
   cd rewire
   ```

2. Unduh dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan pengujian (200 test cases):
   ```bash
   flutter test
   ```

4. Jalankan aplikasi di emulator atau perangkat yang terhubung:
   ```bash
   flutter run
   ```

5. Build file APK release:
   ```bash
   flutter build apk --release
   ```
   File hasil build akan berada di `build/app/outputs/flutter-apk/app-release.apk`.
