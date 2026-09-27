import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'screens/checkin/checkin_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/meditation/active_meditation_screen.dart';
import 'screens/meditation/meditation_complete_screen.dart';
import 'screens/meditation/meditation_home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/preference_service.dart';
import 'services/xp_service.dart';
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
  static const String activeMeditation = '/meditation/active';
  static const String meditationComplete = '/meditation/complete';
  static const String workout = '/workout';
  static const String progress = '/progress';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String checkin = '/checkin';
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
    builder: (context, child) {
      final theme = Theme.of(context);
      return AnimatedTheme(
        data: theme,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: child ?? const SizedBox.shrink(),
      );
    },
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
      GoRoute(
        path: Routes.checkin,
        builder: (context, state) => const CheckinScreen(),
      ),
      GoRoute(
        path: Routes.activeMeditation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ActiveMeditationScreen(
            durationMinutes: extra?['durationMinutes'] as int? ?? 10,
            trackId: extra?['trackId'] as String? ?? 'rain',
            breathingId: extra?['breathingId'] as String?,
          );
        },
      ),
      GoRoute(
        path: Routes.meditationComplete,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MeditationCompleteScreen(
            durationMinutes: extra?['durationMinutes'] as int? ?? 10,
            xpAward: extra?['xpAward'] as XpAward? ??
                const XpAward(
                  amount: 15,
                  totalXpBefore: 0,
                  totalXpAfter: 15,
                  levelBefore: 1,
                  levelAfter: 1,
                ),
          );
        },
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) =>
            _ShellScaffold(navigationShell: navigationShell),
        navigatorContainerBuilder: (context, navigationShell, children) =>
            _SwipeableBranchContainer(
              navigationShell: navigationShell,
              children: children,
            ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) =>
                    const HomeScreen(key: Key('screen-home')),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.meditation,
                builder: (context, state) =>
                    const MeditationHomeScreen(key: Key('screen-meditation')),
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

/// Scope that provides the shared [PageController] across the shell and tabs.
class _ShellPageScope extends InheritedWidget {
  const _ShellPageScope({
    required this.pageController,
    required super.child,
  });

  final PageController pageController;

  static PageController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ShellPageScope>();
    assert(scope != null, 'No _ShellPageScope found in context');
    return scope!.pageController;
  }

  @override
  bool updateShouldNotify(_ShellPageScope oldWidget) =>
      pageController != oldWidget.pageController;
}

/// A container that hosts all branch Navigators in a [PageView], enabling
/// horizontal swipe navigation between tabs while synchronizing with the
/// [navigationShell] and [AppBottomNav].
class _SwipeableBranchContainer extends StatelessWidget {
  const _SwipeableBranchContainer({
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final controller = _ShellPageScope.of(context);
    return PageView(
      controller: controller,
      onPageChanged: (index) {
        if (index != navigationShell.currentIndex) {
          navigationShell.goBranch(index);
        }
      },
      children: children,
    );
  }
}

/// Shell around the active tab: the branch content plus the shared bottom nav.
/// Owns the shared [PageController] so the bottom nav sliding indicator moves
/// 1:1 with user swipe gestures in real time.
class _ShellScaffold extends StatefulWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(_ShellScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = widget.navigationShell.currentIndex;
    if (_pageController.hasClients) {
      final current =
          _pageController.page?.round() ?? _pageController.initialPage;
      if (current != target) {
        _pageController.animateToPage(
          target,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShellPageScope(
      pageController: _pageController,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNav(
          navigationShell: widget.navigationShell,
          pageController: _pageController,
        ),
      ),
    );
  }
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
