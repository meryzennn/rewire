import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../services/preference_service.dart';

/// First-run onboarding: a four-page swipe carousel (content carried over from
/// Task 1) restyled to the Stitch "Onboarding Welcome" screen
/// (projects/4347317367430667480/screens/76dff85b1a75411e959f8289a93d5bd2):
/// a brand header with a step pill, a centered hero, a primary CTA, page dots,
/// and a skip link.
///
/// Completing the flow (or skipping) writes §2.5 `onboarding_completed` through
/// [preferences] and navigates home; the router gate then admits the shell.
///
/// antislop Design Read: first-run onboarding for a recovery-app user, in the
/// Rewire calm sage/cream language (DESIGN.md), dial ENERGY 1 / RHYTHM 1 /
/// MOTION 1. One focal point per page (the hero), one accent (sage primary),
/// identity motif = the "REWIRE JOURNEY" brand cue repeated in the header.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.preferences});

  final PreferenceService preferences;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;
  double _dragDistance = 0;

  // Copy is authoritative from docs/UI.md and Task 1 (Indonesian); Stitch drives
  // only the visual chrome. Kept verbatim, including the welcome brain asset.
  static const _pages = [
    _OnboardingPage(
      title: 'Welcome to Rewire',
      description: 'Mulai perjalanan rewiring otakmu hari ini.',
      image: 'assets/images/onboarding/welcome_brain.png',
      imageLabel: 'Ilustrasi otak Rewire',
    ),
    _OnboardingPage(
      title: 'Tiga Pilar Rewire',
      description: 'Catat progres pemulihanmu, tenangkan pikiran lewat meditasi, dan bergerak dengan olahraga rumahan.',
      icon: Icons.self_improvement_rounded,
      iconLabel: 'Meditasi dan kebugaran',
    ),
    _OnboardingPage(
      title: 'Level Up Otakmu',
      description: 'Aktivitas positif memberimu XP. Seiring progres, otakmu berkembang melalui lima tahap.',
      icon: Icons.psychology_alt_rounded,
      iconLabel: 'Perkembangan otak',
    ),
    _OnboardingPage(
      title: 'Atur Pengingat Harian',
      description: 'Pilih waktu pengingat check-in. Pengingat meditasi dan olahraga juga bisa diatur nanti.',
      icon: Icons.notifications_active_rounded,
      iconLabel: 'Pengingat Rewire',
    ),
  ];

  bool get _isLastPage => _page == _pages.length - 1;

  void _goTo(int page) => setState(() => _page = page);

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dragDistance.abs() < 48 && velocity.abs() < 100) return;
    _goTo(
      (_page + (_dragDistance < 0 || velocity < -100 ? 1 : -1)).clamp(
        0,
        _pages.length - 1,
      ),
    );
    _dragDistance = 0;
  }

  /// Completing the carousel (or tapping skip) transitions to the profile setup screen.
  void _complete() {
    context.go(Routes.profileSetup);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            children: [
              _BrandHeader(step: _page + 1, total: _pages.length),
              Expanded(
                child: GestureDetector(
                  key: const Key('onboarding-pages'),
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (_) => _dragDistance = 0,
                  onHorizontalDragUpdate: (details) =>
                      _dragDistance += details.delta.dx,
                  onHorizontalDragEnd: _handleSwipe,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _PageContent(
                      key: ValueKey(_page),
                      page: _pages[_page],
                      compact: constraints.maxHeight < 700,
                    ),
                  ),
                ),
              ),
              Semantics(
                label: 'Halaman ${_page + 1} dari ${_pages.length}',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _PageDot(active: index == _page),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _isLastPage
                    ? ElevatedButton.icon(
                        onPressed: _complete,
                        // Arrow marks the one forward-completion action (R-08).
                        icon: const Text('Mulai Perjalanan'),
                        label: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => _goTo(_page + 1),
                        child: const Text('Selanjutnya'),
                      ),
              ),
              const SizedBox(height: 4),
              // Skip completes onboarding too (no restore/import in v1).
              TextButton(
                onPressed: _complete,
                child: const SizedBox(
                  height: 44,
                  child: Center(child: Text('Lewati')),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Top brand cue plus a step pill, from the Stitch onboarding header.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primary = isDark ? AppColors.darkPrimary : AppColors.primary;
    final pillBg = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_rounded, size: 18, color: primary),
              const SizedBox(width: 6),
              Text(
                'REWIRE JOURNEY',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: muted, letterSpacing: 1.2),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: divider),
            ),
            child: Text(
              '$step / $total',
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    this.image,
    this.imageLabel,
    this.icon,
    this.iconLabel,
  });

  final String title;
  final String description;
  final String? image;
  final String? imageLabel;
  final IconData? icon;
  final String? iconLabel;
}

class _PageContent extends StatelessWidget {
  const _PageContent({super.key, required this.page, required this.compact});

  final _OnboardingPage page;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final secondary = isDark ? AppColors.darkSecondary : AppColors.secondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Soft aura behind the hero, echoing the Stitch ambient glow. Sized to
        // the hero art; the glow spills past via boxShadow without adding height.
        _HeroAura(
          size: compact ? 140 : 196,
          child: TweenAnimationBuilder<double>(
            key: ValueKey(page.title),
            tween: Tween(begin: 0.94, end: 1),
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: page.image != null
                ? Image.asset(
                    page.image!,
                    key: const Key('welcome-brain'),
                    width: compact ? 132 : 184,
                    height: compact ? 132 : 184,
                    semanticLabel: page.imageLabel,
                  )
                : Icon(
                    page.icon,
                    size: compact ? 96 : 128,
                    color: secondary,
                    semanticLabel: page.iconLabel,
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: textSecondary),
          ),
        ),
      ],
    );
  }
}

/// Diffuse circular glow behind the onboarding hero (decorative, from Stitch).
class _HeroAura extends StatelessWidget {
  const _HeroAura({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow =
        (isDark ? AppColors.darkPrimaryContainer : AppColors.primaryContainer)
            .withValues(alpha: isDark ? 0.35 : 0.55);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glow,
              boxShadow: [
                BoxShadow(color: glow, blurRadius: 48, spreadRadius: 8),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final on = isDark ? AppColors.darkPrimary : AppColors.primary;
    final off = isDark ? AppColors.darkDivider : AppColors.divider;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? on : off,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
