import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

class RewireApp extends StatelessWidget {
  const RewireApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rewire',
    theme: buildLightTheme(),
    darkTheme: buildDarkTheme(),
    themeMode: ThemeMode.system,
    home: const _OnboardingScreen(),
  );
}

class _OnboardingScreen extends StatefulWidget {
  const _OnboardingScreen();

  @override
  State<_OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<_OnboardingScreen> {
  int _page = 0;
  double _dragDistance = 0;

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

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Column(
            children: [
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
                      compact: constraints.maxHeight < 650,
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
              if (_page == _pages.length - 1) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        _showNotReady('Onboarding berikutnya belum tersedia.'),
                    child: const Text('Mulai Sekarang'),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () =>
                        _showNotReady('Pemulihan data belum tersedia.'),
                    child: const SizedBox(
                      height: 48,
                      child: Center(child: Text('Sudah punya data?')),
                    ),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _goTo(_page + 1),
                    child: const Text('Selanjutnya'),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  void _showNotReady(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TweenAnimationBuilder<double>(
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
                width: compact ? 160 : 216,
                height: compact ? 160 : 216,
                semanticLabel: page.imageLabel,
              )
            : Icon(
                page.icon,
                size: compact ? 108 : 144,
                color: Theme.of(context).colorScheme.secondary,
                semanticLabel: page.iconLabel,
              ),
      ),
      Text(
        page.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall
            ?.copyWith(fontWeight: FontWeight.w800, height: 1.1),
      ),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Text(
          page.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textPrimary),
        ),
      ),
    ],
  );
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: active ? 20 : 8,
    height: 8,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: AppColors.textPrimary,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
