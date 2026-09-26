# Rewire — Design Specification

## 1. Overview

**Rewire** is an Android gamified recovery app helping users quit PMO (Porn, Masturbation, Orgasm) through three pillars: streak tracking, meditation (ambient audio), and home exercise (bodyweight only). The core concept is neuroplasticity — "rewiring" the brain through consistent positive habits.

- **Platform:** Android only (v1)
- **Tech stack:** Flutter 3.47+ / Dart 3.13+
- **Architecture:** Offline-first, all data local on device
- **Language:** Indonesian UI text, English code

---

## 2. Architecture

### 2.1 Project Structure

```
lib/
├── main.dart                    # Entry point, app initialization
├── app.dart                     # MaterialApp, theme, routing
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      # Light/dark color tokens
│   │   ├── app_typography.dart  # Nunito type scale
│   │   └── app_theme.dart       # ThemeData builder
│   ├── constants/
│   │   ├── xp_table.dart        # Level-XP requirements (1-50)
│   │   └── assets.dart          # Asset path constants
│   ├── database/
│   │   ├── database_helper.dart # SQLite singleton via sqflite
│   │   └── tables.dart          # Table creation SQL
│   └── utils/
│       ├── date_utils.dart      # Date formatting, streak math
│       └── xp_utils.dart        # XP calculation helpers
├── models/
│   ├── user_profile.dart
│   ├── daily_checkin.dart
│   ├── trigger_entry.dart
│   ├── meditation_session.dart
│   ├── workout_session.dart
│   ├── quest.dart
│   ├── achievement.dart
│   └── streak.dart
├── repositories/
│   ├── user_repository.dart
│   ├── checkin_repository.dart
│   ├── meditation_repository.dart
│   ├── workout_repository.dart
│   ├── quest_repository.dart
│   └── achievement_repository.dart
├── services/
│   ├── audio_service.dart       # Ambient audio playback
│   ├── notification_service.dart# Local notifications
│   ├── quest_service.dart       # Daily quest generation/refresh
│   └── xp_service.dart         # XP granting, level-up detection
├── screens/
│   ├── onboarding/
│   │   ├── onboarding_screen.dart     # PageView with 4 pages
│   │   └── widgets/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── brain_visual.dart      # Animated brain centerpiece
│   │       ├── streak_card.dart
│   │       ├── daily_quests_card.dart
│   │       └── quick_actions.dart
│   ├── checkin/
│   │   ├── checkin_screen.dart
│   │   └── widgets/
│   ├── meditation/
│   │   ├── meditation_home_screen.dart
│   │   ├── active_meditation_screen.dart
│   │   ├── meditation_complete_screen.dart
│   │   └── widgets/
│   │       ├── duration_picker.dart
│   │       ├── sound_list.dart
│   │       └── breathing_circle.dart
│   ├── workout/
│   │   ├── workout_home_screen.dart
│   │   ├── exercise_detail_screen.dart
│   │   ├── active_workout_screen.dart
│   │   ├── rest_timer_screen.dart
│   │   ├── workout_complete_screen.dart
│   │   └── widgets/
│   ├── progress/
│   │   ├── progress_screen.dart
│   │   └── widgets/
│   │       ├── brain_timeline.dart
│   │       ├── stat_cards_grid.dart
│   │       ├── streak_chart.dart
│   │       ├── mood_trend_chart.dart
│   │       ├── weekly_challenges.dart
│   │       └── achievement_grid.dart
│   └── settings/
│       ├── settings_screen.dart
│       └── widgets/
├── widgets/
│   ├── xp_chip.dart             # Animated "+20 XP ✨" chip
│   ├── celebration_overlay.dart # Confetti/celebration animation
│   ├── level_up_dialog.dart     # Level-up announcement
│   └── app_bottom_nav.dart      # Shared bottom navigation
└── data/
    ├── exercises.dart           # Bundled exercise definitions
    ├── routines.dart            # Pre-made workout routines
    ├── quests_definitions.dart  # Quest template pool
    └── achievements_definitions.dart
```

### 2.2 State Management

**Approach: `ChangeNotifier` + `Provider`**

Rationale: Simplest approach for a beginner Flutter developer. No code generation, minimal boilerplate, well-documented. The app's state is straightforward (no complex reactive chains).

Key providers:
- `UserProvider` — level, XP, brain stage, current streak
- `CheckinProvider` — today's check-in status, history
- `MeditationProvider` — active session state, timer
- `WorkoutProvider` — active workout state, timer, current exercise
- `QuestProvider` — today's quests, weekly challenges
- `AchievementProvider` — badge unlock status

Provider scope: All providers wrap the app at the root (`MultiProvider` in `main.dart`). No nested providers needed for this complexity level.

### 2.3 Navigation

**Approach: Flutter's `GoRouter` with `StatefulShellRoute`**

- Bottom navigation with 5 tabs: Home, Meditasi, Olahraga, Progress, Pengaturan
- Each tab maintains its own navigation stack (via `StatefulShellRoute`)
- Modal screens: Check-in, Active Meditation, Active Workout (pushed as full-screen routes)
- Onboarding: Shown once on first launch, controlled by SharedPreferences flag

Route structure:
```
/                         → Home
/checkin                  → Daily Check-in (full screen)
/brain                    → Brain detail view (full screen)
/meditation               → Meditation Home (tab)
/meditation/active        → Active timer (full screen)
/meditation/complete      → Session complete
/workout                  → Workout Home (tab)
/workout/exercise/:id     → Exercise detail
/workout/active/:routineId → Active workout (full screen)
/workout/complete         → Workout complete
/progress                 → Progress & Stats (tab)
/settings                 → Settings (tab)
/onboarding               → Onboarding flow
```

### 2.4 Local Database

**SQLite via `sqflite` package**

Tables (8 total):

```sql
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY DEFAULT 1,
  level INTEGER DEFAULT 1,
  total_xp INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  streak_start_date TEXT,
  brain_stage TEXT DEFAULT 'dormant',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE daily_checkins (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT UNIQUE NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('clean', 'relapse')),
  mood INTEGER CHECK(mood BETWEEN 1 AND 5),
  notes TEXT,
  xp_earned INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE triggers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE meditation_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  audio_type TEXT,
  breathing_type TEXT,
  xp_earned INTEGER DEFAULT 0,
  completed INTEGER DEFAULT 1,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workout_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  routine_id TEXT NOT NULL,
  routine_name TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  exercises_completed INTEGER NOT NULL,
  exercises_total INTEGER NOT NULL,
  xp_earned INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quest_id TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('daily', 'weekly')),
  title TEXT NOT NULL,
  description TEXT,
  xp_reward INTEGER NOT NULL,
  target_value INTEGER DEFAULT 1,
  current_value INTEGER DEFAULT 0,
  completed INTEGER DEFAULT 0,
  date_assigned TEXT NOT NULL,
  date_completed TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE achievements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  badge_id TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  unlocked INTEGER DEFAULT 0,
  date_unlocked TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE streaks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start_date TEXT NOT NULL,
  end_date TEXT,
  length INTEGER NOT NULL,
  ended_by TEXT CHECK(ended_by IN ('relapse', 'active')),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### 2.5 SharedPreferences Keys

```
onboarding_completed: bool
dark_mode: bool
language: String ('id' | 'en')
daily_reminder_enabled: bool
daily_reminder_time: String (HH:mm)
meditation_reminder_enabled: bool
workout_reminder_enabled: bool
last_checkin_date: String (yyyy-MM-dd)
last_quest_refresh_date: String (yyyy-MM-dd)
last_weekly_refresh_date: String (yyyy-MM-dd)
```

---

## 3. Gamification System

### 3.1 XP Sources

| Activity | XP | Condition |
|---|---|---|
| Daily check-in (clean) | +20 | Once per day |
| Meditation complete | +10 to +30 | 5min=10, 10min=15, 15min=20, 20min=25, 30min=30 |
| Workout complete | +15 to +40 | Based on routine duration: ≤10min=15, ≤15min=25, ≤20min=30, >20min=40 |
| Daily quest complete | +25 | Per quest |
| Weekly challenge complete | +100 | Per challenge |
| Streak milestone (7d) | +50 | One-time per streak |
| Streak milestone (14d) | +100 | One-time per streak |
| Streak milestone (30d) | +200 | One-time per streak |
| Streak milestone (60d) | +350 | One-time per streak |
| Streak milestone (90d) | +500 | One-time per streak |

### 3.2 Level Progression (50 levels)

Cumulative XP needed to reach level `L` (L = 1..50):

```dart
int xpToReach(int level) => (50 * pow(level - 1, 1.8)).round();
```

The current level is the highest `L` where `total_xp >= xpToReach(L)`, capped at 50. The full table is precomputed in `core/constants/xp_table.dart`.

| Level | Cumulative XP | Brain Stage |
|---|---|---|
| 1 | 0 | Dormant |
| 2 | 50 | Dormant |
| 5 | 606 | Dormant |
| 6 | 906 | Awakening |
| 10 | 2,610 | Awakening |
| 15 | 5,781 | Awakening |
| 16 | 6,545 | Growing |
| 20 | 10,017 | Growing |
| 25 | 15,253 | Growing |
| 26 | 16,416 | Thriving |
| 30 | 21,443 | Thriving |
| 40 | 36,550 | Thriving |
| 41 | 38,254 | Transcendent |
| 50 | 55,122 | Transcendent |

Pacing reference (~140 XP/day for an active user: check-in + meditation + workout + 3 quests): Awakening ≈ day 7, Growing ≈ day 47, Thriving ≈ day 117, Transcendent ≈ day 273, Level 50 ≈ day 390.

### 3.3 Brain Evolution Stages

| Stage | Level Range | Visual Description |
|---|---|---|
| Dormant | 1–5 | Dark gray brain, almost no neural connections, dim, still |
| Awakening | 6–15 | Small light points appear, a few connections forming, gentle flicker |
| Growing | 16–25 | More lights, neural connections visibly forming, soft steady glow |
| Thriving | 26–40 | Bright glow, dense active neural network, warm light pulses |
| Transcendent | 41–50 | Full luminous glow, perfect neural web, particle aura effects |

Implementation: 5 static SVG/Lottie assets, one per stage. The home screen displays the current stage asset with a subtle idle animation (CSS-like pulse via `AnimationController`). Level-up triggers a burst transition animation before swapping to the next stage asset.

### 3.4 Quest System

**Daily quests** — 3-4 per day, drawn from a pool at midnight (or first app open):
- Pool: "Check-in hari ini", "Meditasi minimal 5 menit", "Selesaikan 1 workout", "Catat 1 trigger", "Meditasi 10 menit", "Selesaikan 2 workout"
- Selection: Random 3-4 from pool, always include "Check-in hari ini"
- Refresh: At midnight local time (checked on app foreground)

**Weekly challenges** — 2-3 per week, assigned Monday:
- Pool: "Meditasi 5 hari minggu ini", "3 workout minggu ini", "Streak 7 hari", "Total 30 menit meditasi", "Check-in setiap hari"
- Selection: Random 2-3 from pool
- Refresh: Monday 00:00 local time

Quest progress auto-updates when relevant activities complete (via `QuestService` listening to repository changes).

### 3.5 Achievements (20 badges)

| Badge ID | Title | Condition |
|---|---|---|
| first_spark | 🔥 First Spark | 1 day clean |
| week_warrior | ⚡ One Week Warrior | 7-day streak |
| two_weeks | 🌟 Fortnight Fighter | 14-day streak |
| lunar_cycle | 🌙 Lunar Cycle | 30-day streak |
| solar_power | ☀️ Solar Power | 90-day streak |
| zen_mind | 🧘 Zen Mind | 100 total meditation minutes |
| deep_focus | 🔮 Deep Focus | 500 total meditation minutes |
| iron_will | 💪 Iron Will | 50 workouts completed |
| marathon | 🏃 Marathon | 100 workouts completed |
| early_bird | 🐦 Early Bird | Check-in before 8 AM, 7 days in a row |
| night_owl | 🦉 Night Owl | Meditate after 10 PM, 5 times |
| consistency | 📅 Consistency King | 30 consecutive daily check-ins |
| explorer | 🗺️ Explorer | Try all 6 ambient sounds |
| full_body | 🏋️ Full Body | Complete all workout routines at least once |
| trigger_aware | 🎯 Trigger Aware | Log 20 triggers |
| bouncer | 🔄 Bouncer | Resume streak within 24h of relapse |
| level_10 | 🌱 Sapling | Reach level 10 |
| level_25 | 🌳 Mighty Oak | Reach level 25 |
| level_50 | 🧠 Fully Rewired | Reach level 50 (max) |
| quest_master | ⭐ Quest Master | Complete 50 daily quests total |

Achievement checking runs after each activity completes (via `AchievementService`).

---

## 4. Content

### 4.1 Exercises (minimum 15 for v1)

| Exercise | Category | Default Sets × Reps | Difficulty |
|---|---|---|---|
| Push-up | Upper | 3×12 | Beginner |
| Knee Push-up | Upper | 3×15 | Beginner |
| Diamond Push-up | Upper | 3×8 | Intermediate |
| Pike Push-up | Upper | 3×10 | Intermediate |
| Squat | Lower | 3×15 | Beginner |
| Lunge | Lower | 3×12 each | Beginner |
| Jump Squat | Lower | 3×10 | Intermediate |
| Wall Sit | Lower | 3×30s | Beginner |
| Plank | Core | 3×30s | Beginner |
| Crunch | Core | 3×15 | Beginner |
| Mountain Climber | Core | 3×20 | Intermediate |
| Bicycle Crunch | Core | 3×15 each | Intermediate |
| Jumping Jack | Cardio | 3×20 | Beginner |
| High Knees | Cardio | 3×20 | Beginner |
| Burpee | Cardio | 3×8 | Intermediate |

### 4.2 Workout Routines (minimum 3 for v1)

**Morning Energy** (15 min, Beginner, 6 exercises):
Jumping Jack → Squat → Push-up → Lunge → Plank → High Knees

**Full Body Burn** (20 min, Intermediate, 8 exercises):
Jumping Jack → Squat → Push-up → Mountain Climber → Lunge → Diamond Push-up → Burpee → Plank

**Core Crusher** (10 min, Beginner, 5 exercises):
Plank → Crunch → Mountain Climber → Bicycle Crunch → Wall Sit

### 4.3 Ambient Audio (6 tracks, bundled as assets)

| Track | File | Estimated Size |
|---|---|---|
| 🌧️ Hujan (Rain) | rain.mp3 | ~3 MB |
| 🌊 Ombak Laut (Ocean) | ocean.mp3 | ~3 MB |
| 🌲 Hutan (Forest) | forest.mp3 | ~3 MB |
| 📻 White Noise | whitenoise.mp3 | ~2 MB |
| 🎵 Lo-fi Ambient | lofi.mp3 | ~3 MB |
| 🔥 Campfire | campfire.mp3 | ~3 MB |

Total: ~17 MB. All tracks loop seamlessly. Format: MP3, 128kbps, mono.

### 4.4 Breathing Exercises (2 patterns)

**Box Breathing (4-4-4-4):**
Inhale 4s → Hold 4s → Exhale 4s → Hold 4s → repeat

**4-7-8 Breathing:**
Inhale 4s → Hold 7s → Exhale 8s → repeat

Visual: Animated circle that expands (inhale), holds (hold), contracts (exhale). Text label shows current phase + countdown.

---

## 5. Design System

### 5.1 Color Tokens

Fully defined in `DESIGN.md` and `UI.md`. Implementation via `app_colors.dart`:

```dart
class AppColors {
  // Light mode
  static const background = Color(0xFFFAF8F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0EDE8);
  static const primary = Color(0xFF8FAE8B);
  static const primaryContainer = Color(0xFFD4E8D2);
  static const secondary = Color(0xFFA8A0C8);
  static const secondaryContainer = Color(0xFFDDD8EE);
  static const accent = Color(0xFF6BA8A0);
  static const textPrimary = Color(0xFF2D2D2D);
  static const textSecondary = Color(0xFF7A7A7A);
  static const success = Color(0xFF7BC67E);
  static const warning = Color(0xFFE8B86D);
  static const danger = Color(0xFFD4836D);
  static const divider = Color(0xFFE8E4DF);

  // Dark mode
  static const darkBackground = Color(0xFF1A1A2E);
  static const darkSurface = Color(0xFF22223B);
  static const darkSurfaceVariant = Color(0xFF2A2A45);
  static const darkPrimary = Color(0xFF9EC49A);
  static const darkPrimaryContainer = Color(0xFF3A5038);
  static const darkSecondary = Color(0xFFB8B0D8);
  static const darkSecondaryContainer = Color(0xFF4A4468);
  static const darkAccent = Color(0xFF7DBDB5);
  static const darkTextPrimary = Color(0xFFE8E8E8);
  static const darkTextSecondary = Color(0xFF9A9A9A);
  static const darkDivider = Color(0xFF3A3A55);
}
```

### 5.2 Typography

Font: **Nunito** (via `google_fonts` package), fallback to Inter.

9-level type scale matching Material Design 3, all defined in `UI.md` and `DESIGN.md`. Implementation via `app_typography.dart` using `GoogleFonts.nunito()` with explicit sizes and weights.

### 5.3 Components

All component specs (buttons, cards, chips, inputs, progress bars, navigation) defined in `DESIGN.md` section 4. Key principles:
- Pill-shaped primary buttons (12dp radius)
- Cards: 16dp radius, no shadow, background differentiation only
- 0dp elevation everywhere except modals (8dp)
- 20dp horizontal screen padding
- 16dp between cards, 24dp between sections

### 5.4 Visual Mockups

All 7 core screens have been designed in Google Stitch (project ID: `4347317367430667480`) with the "Serene Organic" design system applied consistently:

| Screen | Stitch Screen ID |
|---|---|
| Home | `242853df00e24a648cb936a68b6dcc8e` |
| Daily Check-in | `65f4ab2ac4794e7e95e8294e4c5ed56f` |
| Meditation | `6cb6b51d5c4b49c39d621e21986b3948` |
| Workout Home | `f5fb3a15df3c46c49c1a3dbeb328a58c` |
| Progress & Stats | `9793a10ea659491ba0d42832bd4e99cd` |
| Onboarding Welcome | `76dff85b1a75411e959f8289a93d5bd2` |
| Settings | `35532a33b536478aa961e4f08bd4ee98` |

---

## 6. Key Dependencies

| Package | Purpose | Version Constraint |
|---|---|---|
| `provider` | State management | ^6.0.0 |
| `go_router` | Navigation/routing | ^14.0.0 |
| `sqflite` | SQLite database | ^2.3.0 |
| `shared_preferences` | Simple key-value storage | ^2.2.0 |
| `google_fonts` | Nunito font loading | ^6.1.0 |
| `audioplayers` | Ambient audio playback | ^6.0.0 |
| `flutter_local_notifications` | Daily reminders | ^17.0.0 |
| `fl_chart` | Streak/mood charts | ^0.68.0 |
| `lottie` | Brain animation (if using Lottie) | ^3.1.0 |
| `intl` | Date formatting | ^0.19.0 |
| `path_provider` | File system paths | ^2.1.0 |
| `wakelock_plus` | Keep screen on during meditation | ^1.2.0 |

No backend, no HTTP, no Firebase, no analytics.

---

## 7. Audio Service Design

```
AudioService (singleton)
├── play(trackName)     → Start looping ambient audio
├── pause()             → Pause playback
├── resume()            → Resume playback
├── stop()              → Stop and release
├── setVolume(0.0-1.0)  → Volume control
├── isPlaying: bool     → Current state
└── currentTrack: String?

Implementation: audioplayers package with AssetSource.
Tracks loaded from assets/audio/.
Loop mode: AudioPlayer.setReleaseMode(ReleaseMode.loop)
Audio session: Plays in background, respects system volume.
Keep alive during active meditation (WakelockPlus).
```

---

## 8. Notification Service Design

```
NotificationService
├── initialize()                    → Request permissions, init plugin
├── scheduleDailyReminder(time)     → Daily check-in reminder
├── scheduleMeditationReminder(time)→ Meditation reminder
├── scheduleWorkoutReminder(time)   → Workout reminder
├── cancelAll()                     → Cancel all scheduled
└── showInstant(title, body)        → One-off notification (level up, etc.)

Implementation: flutter_local_notifications
Channel: "rewire_reminders" (importance: high)
Scheduling: via zonedSchedule with matchDateTimeComponents
```

---

## 9. Screens Specification

All screen layouts, wireframes, component placement, typography usage, color assignments, navigation flows, and micro-interaction specs are fully detailed in `docs/UI.md` (864 lines). That document is the authoritative reference for implementing each screen.

Key screens summary:
1. **Onboarding** — 4-page PageView (Welcome, Three Pillars, Gamification Intro, Set Reminder)
2. **Home** — Brain centerpiece + streak card + daily quests + quick actions + bottom nav
3. **Daily Check-in** — Status selection (clean/relapse) + mood selector + trigger input + encouraging relapse message
4. **Meditation** — Duration picker + sound list + breathing exercise selector → Active timer (minimal UI, dimmed) → Complete screen
5. **Workout** — Routine cards + exercise list with category filters → Exercise detail → Active workout with set tracking → Rest timer → Complete screen
6. **Progress** — Brain timeline + 6 stat cards grid + streak chart + mood trend + weekly challenges + achievement badge grid
7. **Settings** — Profile summary + dark mode toggle + notification settings + data export/import/reset + about

---

## 10. Testing Strategy

### Unit Tests
- XP calculation logic
- Level-up threshold detection
- Brain stage determination from level
- Quest selection and refresh logic
- Streak counting and reset logic
- Date utility functions

### Widget Tests
- Each major widget renders correctly with mock data
- Button states (enabled/disabled)
- Form validation on check-in screen

### Integration Tests
- Full check-in flow: select status → mood → save → XP awarded → quest updated
- Meditation flow: select duration/sound → timer runs → complete → XP awarded
- Workout flow: start routine → complete sets → rest timer → complete → XP awarded
- Level-up trigger: earn enough XP → level up dialog shown → brain stage updates

---

## 11. Asset Requirements

```
assets/
├── audio/
│   ├── rain.mp3         (~3 MB, loopable)
│   ├── ocean.mp3        (~3 MB, loopable)
│   ├── forest.mp3       (~3 MB, loopable)
│   ├── whitenoise.mp3   (~2 MB, loopable)
│   ├── lofi.mp3         (~3 MB, loopable)
│   └── campfire.mp3     (~3 MB, loopable)
├── images/
│   ├── brain/
│   │   ├── dormant.svg (or .json for Lottie)
│   │   ├── awakening.svg
│   │   ├── growing.svg
│   │   ├── thriving.svg
│   │   └── transcendent.svg
│   ├── exercises/
│   │   ├── pushup.svg
│   │   ├── squat.svg
│   │   ├── plank.svg
│   │   └── ... (15 total)
│   └── onboarding/
│       └── welcome_brain.svg
├── data/
│   ├── exercises.json
│   ├── routines.json
│   ├── quests.json
│   └── achievements.json
└── fonts/
    └── (Nunito loaded via google_fonts, no bundled fonts needed)
```

Total estimated app size: ~25-35 MB (mostly audio).

---

## 12. Out of Scope (v1)

- iOS support (Flutter can build it, but not tested/released in v1)
- Cloud backup / sync
- Community features
- Custom workout builder
- Journaling feature
- Monetization / premium tiers
- Home screen widget
- Multi-language support (Indonesian only for v1; English is a future add)
- Adaptive/responsive layouts for tablets

---

## 13. Success Criteria

A v1 release is complete when:

- [ ] Onboarding flow works end-to-end
- [ ] Daily check-in tracks clean/relapse status with mood and trigger logging
- [ ] Streak counter increments, resets on relapse, persists
- [ ] Meditation timer plays ambient audio for selected duration
- [ ] All 6 ambient tracks play and loop correctly
- [ ] Breathing exercise animation works (box breathing + 4-7-8)
- [ ] At least 15 exercises with illustrations are browsable
- [ ] At least 3 workout routines are completable with rest timers
- [ ] XP earned from all activities, level progression works
- [ ] Brain visual changes across 5 stages based on level
- [ ] Daily quests generate and track progress
- [ ] Weekly challenges generate and track progress
- [ ] At least 10 achievement badges are earnable
- [ ] Progress screen shows stats, charts, and achievements
- [ ] Settings: dark mode, notification reminders, data reset
- [ ] All data persists locally via SQLite
- [ ] App works fully offline
- [ ] Dark mode fully themed
