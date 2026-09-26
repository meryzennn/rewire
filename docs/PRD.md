# Rewire — Product Requirements Document

## Overview

**Rewire** adalah aplikasi Android gamified recovery journey yang membantu user "rewire" otak dari kebiasaan PMO (Porn, Masturbation, Orgasm) melalui tiga pilar utama: streak tracking, meditasi, dan olahraga rumahan.

Konsep utama: **neuroplastisitas** — otak bisa membentuk koneksi neural baru melalui kebiasaan positif yang konsisten.

## Project Meta

- **Platform:** Android only
- **Tech Stack:** Flutter 3.47+ / Dart 3.13+
- **Architecture:** Offline-first, semua data lokal di device
- **Monetisasi:** Tidak ada (passion project / portfolio)
- **Target User:** Pria 16-35 tahun yang ingin berhenti PMO dan membangun kebiasaan sehat

---

## Core Pillars

### 1. 🧠 Streak & Recovery Tracking

- **Streak Counter:** Menghitung hari berturut-turut bebas PMO
- **Daily Check-in:** User konfirmasi status harian (clean / relapse)
- **Relapse Handling:** Kalau relapse, streak reset tapi XP total tidak hilang. Ada mekanisme "bouncing back" — bukan punish, tapi encourage untuk mulai lagi
- **Mood Tracker:** Sederhana (1-5 emoji) saat check-in, buat user sadar pola emosi
- **Trigger Logger:** User bisa catat apa yang trigger urge, buat self-awareness
- **Stats & Progress:** Streak terpanjang, total hari clean, grafik progress mingguan/bulanan

### 2. 🧘 Meditasi

- **Timer-based:** Bukan guided voice, user set durasi sendiri (5/10/15/20/30 menit atau custom)
- **Ambient Audio:** Background sound yang menenangkan:
  - Hujan
  - Ombak laut
  - Hutan / burung
  - White noise
  - Lo-fi ambient
  - Campfire
- **Audio bundled** di dalam app (offline-first)
- **Breathing Exercise:** Animasi sederhana untuk teknik napas (4-7-8, box breathing)
- **Session History:** Log meditasi selesai, total menit meditasi

### 3. 💪 Olahraga Rumahan

- **Bodyweight only** — tidak perlu alat sama sekali
- **Kategori gerakan:**
  - Upper body (push-up, plank, dll)
  - Lower body (squat, lunges, dll)
  - Core (sit-up, crunch, mountain climber, dll)
  - Stretching / flexibility
  - Cardio ringan (jumping jack, high knees, dll)
- **Setiap gerakan punya:**
  - Ilustrasi/gambar posisi (flat illustration style)
  - Jumlah rep / durasi
  - Level kesulitan (beginner / intermediate)
  - Instruksi teks singkat
- **Workout Routines:** Pre-made routine yang combine beberapa gerakan (10-20 menit)
- **Rest Timer:** Timer otomatis antar set
- **Session History:** Log workout selesai, total menit olahraga

---

## Gamification System

### XP (Experience Points)

Sumber XP:
| Aktivitas | XP |
|---|---|
| Daily check-in (clean) | +20 XP |
| Meditasi selesai | +10-30 XP (berdasarkan durasi) |
| Workout selesai | +15-40 XP (berdasarkan durasi & intensitas) |
| Daily quest complete | +25 XP |
| Weekly challenge complete | +100 XP |
| Streak milestone (7/14/30/60/90 hari) | +50-500 XP (scaling) |

### Level System

- Level 1-50 (atau lebih)
- XP requirement scaling per level (misal Level 2 = 100 XP, Level 10 = 1000 XP, dst)
- Setiap naik level ada notifikasi celebratory
- Level tertentu unlock konten baru (workout routine baru, ambient sound baru, badge baru)

### Brain Evolution (Karakter Utama)

Otak yang evolve visual-nya seiring level naik:

| Stage | Level Range | Visual |
|---|---|---|
| Dormant | 1-5 | Otak gelap, abu-abu, hampir tidak ada koneksi neuron |
| Awakening | 6-15 | Mulai ada titik-titik cahaya kecil, beberapa koneksi muncul |
| Growing | 16-25 | Cahaya makin banyak, koneksi neuron mulai terbentuk jelas |
| Thriving | 26-40 | Otak bercahaya terang, jaringan neuron padat dan aktif |
| Transcendent | 41-50 | Full glow, particle effects, koneksi neuron sempurna, aura |

Evolusi visual ini jadi centerpiece di home screen.

### Quest System

**Daily Quests (refresh setiap hari):**
- "Meditasi minimal 5 menit"
- "Selesaikan 1 workout routine"
- "Check-in hari ini"
- "Catat 1 trigger di logger"
- Biasanya 3-4 quest per hari

**Weekly Challenges (refresh setiap Senin):**
- "Meditasi 5 hari berturut-turut minggu ini"
- "Selesaikan 3 workout routine minggu ini"
- "Capai streak 7 hari"
- Biasanya 2-3 challenge per minggu

### Badges / Achievements

Milestone badges:
- 🔥 "First Spark" — 1 hari clean
- ⚡ "One Week Warrior" — 7 hari streak
- 🌙 "Lunar Cycle" — 30 hari streak
- ☀️ "Solar Power" — 90 hari streak
- 🧘 "Zen Mind" — Total 100 menit meditasi
- 💪 "Iron Will" — Total 50 workout selesai
- 🧠 "Fully Rewired" — Capai level max
- Dan lain-lain...

---

## Design & Visual Identity

### Color Palette (Soft & Muted)

**Light Mode:**
- Background: Warm cream `#FAF8F5`
- Primary: Sage green `#8FAE8B`
- Secondary: Dusty lavender `#A8A0C8`
- Accent: Muted teal `#6BA8A0`
- Text primary: Charcoal `#2D2D2D`
- Text secondary: Warm gray `#7A7A7A`
- Success: Soft green `#7BC67E`
- Warning/Danger: Muted coral `#D4836D`

**Dark Mode:**
- Background: Deep slate `#1A1A2E`
- Surface: Dark navy `#22223B`
- Primary: Sage green (slightly brighter) `#9EC49A`
- Secondary: Lavender (slightly brighter) `#B8B0D8`
- Text primary: Off-white `#E8E8E8`
- Text secondary: Muted gray `#9A9A9A`

### Typography

- Font: **Inter** atau **Nunito** (rounded, friendly, mudah dibaca)
- Headings: Semi-bold / Bold
- Body: Regular
- Sizes mengikuti Material Design 3 type scale

### Visual Style

- Flat illustrations dengan rounded shapes
- Minimalis, clean, banyak whitespace
- Rounded corners (16-20dp radius)
- Soft shadows (elevation rendah)
- Smooth transitions dan micro-animations
- Iconography: Rounded line icons (Lucide / Phosphor style)

---

## Data Storage

### Local Database: SQLite via `sqflite` atau `drift`

**Tables:**
- `user_profile` — level, total XP, settings
- `daily_checkins` — tanggal, status (clean/relapse), mood, notes
- `triggers` — tanggal, deskripsi trigger
- `meditation_sessions` — tanggal, durasi, audio used
- `workout_sessions` — tanggal, routine name, durasi, exercises completed
- `quests` — quest list, status, tanggal
- `achievements` — badge id, unlocked status, tanggal unlock
- `streaks` — current streak, longest streak, start date

### Shared Preferences

- Settings (notifikasi on/off, dark mode, dll)
- Onboarding completed flag
- Last check-in date

---

## Content Delivery

- **Olahraga:** Daftar gerakan + ilustrasi bundled sebagai assets di app
- **Meditasi audio:** File audio (.mp3/.ogg) bundled di assets
  - Estimasi: 6-8 ambient tracks × ~2-3 MB each = ~15-25 MB total
- **Quest & achievement definitions:** JSON file di assets, mudah di-update

---

## Key Screens (High Level)

1. **Onboarding** — Welcome, motivasi singkat, set daily reminder
2. **Home** — Brain visualization (centerpiece), streak counter, daily quests, quick actions
3. **Check-in** — Daily status (clean/relapse), mood, trigger log
4. **Meditation** — Pilih audio + durasi, timer screen, breathing exercise
5. **Workout** — Browse routines, exercise detail, active workout timer
6. **Progress** — Stats, grafik, achievements, brain evolution timeline
7. **Settings** — Reminder, dark mode, reset data, about

---

## Future Considerations (Out of Scope v1)

- iOS support (Flutter sudah cross-platform, tinggal build)
- Cloud backup / sync
- Community features
- Custom workout builder
- Journaling
- Monetisasi / premium
- Widget home screen

---

## Success Criteria (v1 Launch)

- [ ] User bisa daily check-in dan track streak
- [ ] Meditasi timer berjalan dengan ambient audio
- [ ] Minimal 10 bodyweight exercises dengan ilustrasi
- [ ] Minimal 3 pre-made workout routines
- [ ] XP & level system berfungsi
- [ ] Brain evolution visual berubah sesuai level
- [ ] Daily quest system aktif
- [ ] Minimal 10 achievement badges
- [ ] Offline-first, semua fitur jalan tanpa internet
- [ ] Dark mode support
- [ ] Data persist di local storage
