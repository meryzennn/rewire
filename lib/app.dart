import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/preference_service.dart';
import 'widgets/app_bottom_nav.dart';

/// SharedPreferences key for the first-run gate (spec §2.5). Aliases the
/// canonical key in [PrefKeys] so existing callers keep working.
const String kOnboardingCompletedKey = PrefKeys.onboardingCompleted;

/// Route paths, verbatim from spec §2.3. The five tab paths are the app's
/// navigation contract; modal/full-screen routes (/checkin, /brain,
/// /meditation/active, ...) are added by their owning screen tasks.
class Routes {
  const Routes._();

  static const String home = '/';
  static const String meditation = '/meditation';
  static const String workout = '/workout';
  static const String progress = '/progress';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
}

/// The root Rewire app: themed [MaterialApp.router] driven by [router].
///
/// [preferences] drives [MaterialApp.themeMode] live: when the settings screen
/// toggles dark mode it notifies, and this rebuilds with the new theme. Left
/// null (e.g. in router tests) the app follows the system theme.
class RewireApp extends StatelessWidget {
  const RewireApp({super.key, required this.router, this.preferences});

  final GoRouter router;
  final PreferenceService? preferences;

  Widget _app(ThemeMode mode) => MaterialApp.router(
    title: 'Rewire',
    theme: buildLightTheme(),
    darkTheme: buildDarkTheme(),
    themeMode: mode,
    routerConfig: router,
  );

  @override
  Widget build(BuildContext context) {
    final prefs = preferences;
    if (prefs == null) return _app(ThemeMode.system);
    return AnimatedBuilder(
      animation: prefs,
      builder: (context, _) => _app(prefs.themeMode),
    );
  }
}

/// Builds the app router: a five-tab [StatefulShellRoute.indexedStack] so each
/// tab keeps its own stack, plus the onboarding route and first-run gate.
///
/// [prefs] is read synchronously in the redirect, so the gate reacts to the
/// onboarding-completed flag without an async round-trip on every navigation.
/// [preferences] (defaulting to one built over [prefs]) is threaded into the
/// onboarding and settings screens; [onResetData] wipes the local database for
/// the settings reset flow (a no-op by default, for tests without a DB).
GoRouter buildRouter(
  SharedPreferences prefs, {
  PreferenceService? preferences,
  Future<void> Function()? onResetData,
}) {
  final prefService = preferences ?? PreferenceService(prefs);
  final resetData = onResetData ?? () async {};
  return GoRouter(
    initialLocation: Routes.home,
    redirect: (context, state) {
      final completed = prefs.getBool(kOnboardingCompletedKey) ?? false;
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!completed) return atOnboarding ? null : Routes.onboarding;
      if (atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) =>
            OnboardingScreen(preferences: prefService),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _ShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) =>
                    const _TabPlaceholder(navKey: 'screen-home', title: 'Home'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.meditation,
                builder: (context, state) => const _TabPlaceholder(
                  navKey: 'screen-meditation',
                  title: 'Meditasi',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.workout,
                builder: (context, state) => const _TabPlaceholder(
                  navKey: 'screen-workout',
                  title: 'Olahraga',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.progress,
                builder: (context, state) => const _TabPlaceholder(
                  navKey: 'screen-progress',
                  title: 'Progress',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => SettingsScreen(
                  preferences: prefService,
                  onResetData: resetData,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Shell around the active tab: the branch content plus the shared bottom nav.
class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: AppBottomNav(navigationShell: navigationShell),
  );
}

/// Stand-in for a tab screen until its screen task lands (Tasks 7-12). Stateful
/// so the router tests can prove each branch's state is retained across tab
/// switches. Shows a single centered label; no placeholder logic beyond that.
class _TabPlaceholder extends StatefulWidget {
  const _TabPlaceholder({required this.navKey, required this.title});

  final String navKey;
  final String title;

  @override
  State<_TabPlaceholder> createState() => _TabPlaceholderState();
}

class _TabPlaceholderState extends State<_TabPlaceholder> {
  @override
  Widget build(BuildContext context) => Scaffold(
    key: Key(widget.navKey),
    appBar: AppBar(title: Text(widget.title)),
    body: Center(
      child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
