# Rewire Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Rewire Android v1 app specified in the design document.

**Architecture:** Offline-first Flutter app using Provider/ChangeNotifier, GoRouter shell navigation, SQLite repositories, and local services. Build in dependency order; each task ends with a runnable test/check and focused commit.

**Tech Stack:** Flutter 3.47+, Dart 3.13+, provider, go_router, sqflite, shared_preferences, audioplayers, flutter_local_notifications, fl_chart, lottie, intl, path_provider, wakelock_plus, google_fonts.

**Spec:** `docs/superpowers/specs/2026-09-26-rewire-design.md`; screen layouts: `docs/UI.md`; visual tokens: `DESIGN.md`.

## Global Constraints

- Android only; Indonesian UI; English identifiers; offline-first, no backend, HTTP, Firebase, analytics.
- Use `ChangeNotifier` + `provider`; `MultiProvider` at root; `go_router` `StatefulShellRoute` with five tabs.
- SQLite `sqflite` owns eight spec tables; SharedPreferences stores only listed preferences.
- Preserve XP formula, thresholds, streak behavior, quest rules, content inventories, and screen flows exactly as specified.
- Keep audio and brain/exercise assets local. No generated-code dependency or new package beyond §6 of spec.
- Follow `docs/UI.md` for screen details and `DESIGN.md` for palette, Nunito, spacing, and component style.

---

### Task 1: Scaffold, dependencies, theme

**Files:** `pubspec.yaml`, `lib/main.dart`, `lib/app.dart`, `lib/core/theme/{app_colors,app_typography,app_theme}.dart`, `test/widget_test.dart`.

**Interfaces:** `ThemeData buildLightTheme()`, `ThemeData buildDarkTheme()`; `AppColors` static const tokens copied from spec §5.1.

- [ ] Create Android project in this directory with `flutter create --platforms=android .`; add dependencies/asset declarations from spec §6/§11; enable Material 3.
- [ ] Test first: replace smoke test with one asserting the `Rewire` app root builds; run `flutter test` and confirm initial failure if app entry is absent.
- [ ] Implement themes using Nunito `GoogleFonts.nunitoTextTheme`, palettes from spec and light/dark `ThemeData`; keep app root minimal.
- [ ] Run `flutter pub get && flutter test`; commit `feat: scaffold Rewire app and themes`.

### Task 2: XP, stages, date utilities

**Files:** `lib/core/constants/xp_table.dart`, `lib/core/utils/{xp_utils,date_utils}.dart`, `test/core/utils/{xp_utils,date_utils}_test.dart`.

**Interfaces:** `int xpToReach(int level)`, `int levelForXp(int totalXp)`, `String brainStageForLevel(int level)`, date format/clean-streak helpers. Clamp levels to 1–50; stage IDs: `dormant`, `awakening`, `growing`, `thriving`, `transcendent`.

- [ ] Write tests for spec checkpoints (XP L1=0, L2=50, L50=55122), boundaries, stage ranges, date rollover/leap day; run `flutter test test/core` (fail first).
- [ ] Implement formula from §3.2 and deterministic local-date helpers; precompute levels 1–50.
- [ ] Run tests; commit `feat: add progression and date utilities`.

### Task 3: SQLite and models

**Files:** `lib/core/database/{tables,database_helper}.dart`, `lib/models/{user_profile,daily_checkin,trigger_entry,meditation_session,workout_session,quest,achievement,streak}.dart`, `test/core/database/database_helper_test.dart`, model tests.

**Interfaces:** `DatabaseHelper.instance.database: Future<Database>`; each model `fromMap(Map<String,Object?>)` and `toMap()`.

- [ ] Add schema tests checking all eight tables, constraints, defaults and unique dates/IDs; model round-trip tests; use an in-memory sqflite test database.
- [ ] Create schema exactly from spec §2.4, versioned initialization; map nullable SQL fields correctly.
- [ ] Run database/model tests; commit `feat: add local database and models`.

### Task 4: Repositories

**Files:** `lib/repositories/{user,checkin,meditation,workout,quest,achievement}_repository.dart`, matching repository tests.

**Interfaces:** repositories accept a `Database`; expose typed CRUD/history methods and transactional mutations. Check-in upsert is unique per local date; XP updates are additive.

- [ ] Write tests for insert/read/update, date uniqueness, history totals, and transaction rollback using in-memory SQLite.
- [ ] Implement only queries required by screens/services; keep SQL in repositories.
- [ ] Run repository tests; commit `feat: add data repositories`.

### Task 5: XP, quests, achievements

**Files:** `lib/services/{xp_service,quest_service,achievement_service}.dart`, `lib/data/{quests_definitions,achievements_definitions}.dart`, matching service tests.

**Interfaces:** `XpService.award(int amount): Future<XpAward>` (before/after levels); `QuestService.refreshIfNeeded(DateTime now)`, `recordActivity(...)`; `AchievementService.checkAndUnlock(): Future<List<Achievement>>`.

- [ ] Test XP rules, no duplicate daily XP, deterministic daily/weekly assignment (always daily check-in; Monday weekly), progress and one-time unlocks against spec §3.
- [ ] Implement transactional awards and checks. Seed all 20 achievement definitions and exact quest pools.
- [ ] Run service tests; commit `feat: implement XP quests and achievements`.

### Task 6: Providers and app routing

**Files:** `lib/providers/{user,checkin,meditation,workout,quest,achievement}_provider.dart`, `lib/app.dart`, `lib/main.dart`, `lib/widgets/app_bottom_nav.dart`, router tests.

**Interfaces:** six root `ChangeNotifier` providers; `GoRouter` paths from spec §2.3; five-tab `StatefulShellRoute`.

- [ ] Test route destinations, tab stack retention and first-run onboarding gate.
- [ ] Wire repositories/services/providers in `MultiProvider`; route placeholders may only persist until their screen task lands.
- [ ] Run `flutter test`; commit `feat: wire providers and navigation`.

### Task 7: Onboarding and settings persistence

**Files:** `lib/screens/onboarding/onboarding_screen.dart`, `lib/screens/settings/settings_screen.dart`, preference service if needed, widget tests.

- [ ] Test four-page onboarding completion and preference persistence (theme, reminder toggles/time); reset requires confirmation.
- [ ] Implement screens per `docs/UI.md`; only keys in spec §2.5. Keep Indonesian UI copy.
- [ ] Run targeted tests; commit `feat: add onboarding and settings`.

### Task 8: Check-in, streak, triggers

**Files:** `lib/screens/checkin/checkin_screen.dart`, `lib/screens/home/widgets/streak_card.dart`, check-in provider/repository updates, widget/integration tests.

- [x] Test clean/relapse, mood 1–5, trigger save, same-day duplicate prevention, streak reset and XP preservation; include relapse encouragement.
- [x] Implement save as one transaction; clean check-in awards +20 once; relapse ends streak without reducing lifetime XP; update quests/achievements.
- [x] Run targeted tests; commit `feat: add recovery check-ins and streaks`.

### Task 9: Home and brain evolution

**Files:** `lib/screens/home/{home_screen.dart,widgets/brain_visual.dart,widgets/streak_card.dart,widgets/daily_quests_card.dart,widgets/quick_actions.dart}`, `lib/widgets/{xp_chip,celebration_overlay,level_up_dialog}.dart`.

- [ ] Widget-test stage/level/streak/quest rendering and level-up event.
- [ ] Implement spec UI; map brain stage to five local assets; subtle idle pulse and level-up transition. Missing asset must show styled fallback, not crash.
- [ ] Run tests; commit `feat: build home and progression visuals`.

### Task 10: Meditation

**Files:** `lib/services/audio_service.dart`, `lib/screens/meditation/{meditation_home_screen,active_meditation_screen,meditation_complete_screen}.dart`, widgets, provider, tests.

**Interfaces:** `AudioService.play(String trackName)`, `pause()`, `resume()`, `stop()`, `setVolume(double)`, `isPlaying`, `currentTrack`.

- [ ] Test duration XP mapping, completion persistence, breathing phase timing; use fake audio service for widget tests.
- [ ] Implement 5/10/15/20/30/custom timer, six looping bundled tracks, box and 4-7-8 breathing, wakelock during active session; award XP only on completion.
- [ ] Run tests; commit `feat: add offline meditation`.

### Task 11: Exercises and workouts

**Files:** `lib/data/{exercises,routines}.dart`, `lib/screens/workout/{workout_home_screen,exercise_detail_screen,active_workout_screen,rest_timer_screen,workout_complete_screen}.dart`, provider/tests.

- [ ] Test all 15 exercises/3 routines, set advancement, rest timer, completion XP brackets and persistence.
- [ ] Implement definitions exactly from spec §4.1–4.2, category filter, active sets/rest, local illustration fallback; award XP on completion only.
- [ ] Run tests; commit `feat: add bodyweight workouts`.

### Task 12: Progress and charts

**Files:** `lib/screens/progress/{progress_screen.dart,widgets/brain_timeline.dart,widgets/stat_cards_grid.dart,widgets/streak_chart.dart,widgets/mood_trend_chart.dart,widgets/weekly_challenges.dart,widgets/achievement_grid.dart}`, widget tests.

- [ ] Test empty and populated history rendering, stats, chart series and badge state.
- [ ] Implement from `docs/UI.md` using `fl_chart`; query persisted aggregates, handle empty history without errors.
- [ ] Run tests; commit `feat: add progress dashboard`.

### Task 13: Notifications and lifecycle

**Files:** `lib/services/notification_service.dart`, `lib/main.dart`, settings/provider updates, service tests.

**Interfaces:** `initialize()`, `scheduleDailyReminder(TimeOfDay time)`, `scheduleMeditationReminder(TimeOfDay time)`, `scheduleWorkoutReminder(TimeOfDay time)`, `cancelAll()`, `showInstant(String title,String body)`.

- [ ] Test schedule/cancel decisions via injected plugin adapter or mock; verify disabled reminders are canceled and local time is used.
- [ ] Implement Android permission/channel `rewire_reminders`, timezone-safe daily schedules; request notification permission only when user enables reminders.
- [ ] Run tests; commit `feat: add local reminders`.

### Task 14: Assets, integration, release check

**Files:** `assets/**`, `integration_test/app_flow_test.dart`, `README.md` if present.

- [ ] Bundle six audio files, five brain stage assets, 15 exercise illustrations, onboarding art, and four JSON/content definitions; verify declared paths resolve. Use original/licensed assets only.
- [ ] Add integration tests for check-in→XP/quest, meditation→XP, workout→XP, and level-up→stage. Use deterministic fixtures; do not depend on real audio playback.
- [ ] Run `dart format .`, `flutter analyze`, `flutter test`, `flutter test integration_test`; resolve all failures. Build with `flutter build apk --debug` on Android toolchain.
- [ ] Commit `test: verify core recovery journeys`.

## Final coverage check

Tasks 1–14 cover all spec sections: architecture/storage (§2), progression/quests/achievements (§3), content (§4), design (§5), packages/services (§6–8), screens (§9), tests (§10), assets (§11), and launch criteria (§13). Multi-language, cloud sync, analytics, iOS and other §12 exclusions remain out of scope.
