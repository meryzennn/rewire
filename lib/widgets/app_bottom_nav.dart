import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';

/// One tab in the bottom navigation. Icons are concrete (home, meditation,
/// workout, stats, settings), not generic glyphs, so each reads as its screen.
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// The five-tab bottom navigation bar, wired to the [StatefulNavigationShell]
/// and an optional [PageController] for 1:1 real-time sliding pill animation.
///
/// Design (DESIGN.md §4 Navigation): 64dp bar on the Clean Canvas surface, flat
/// (no shadow), separated from content by a hairline divider. The active tab is
/// marked by a single sliding Sage Whisper (primary-container) pill behind the
/// icon plus a heavier label; inactive tabs use outline icons in Warm Stone.
///
/// By using a single sliding pill layer in the background, we eliminate any
/// color-lerping to transparent (which previously produced a temporary dark shadow)
/// and allow the indicator to follow user swipe gestures continuously.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.navigationShell,
    this.pageController,
  });

  final StatefulNavigationShell navigationShell;
  final PageController? pageController;

  static const _items = <_NavItem>[
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.self_improvement_outlined,
      activeIcon: Icons.self_improvement_rounded,
      label: 'Meditasi',
    ),
    _NavItem(
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center_rounded,
      label: 'Olahraga',
    ),
    _NavItem(
      icon: Icons.insights_outlined,
      activeIcon: Icons.insights_rounded,
      label: 'Progress',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Pengaturan',
    ),
  ];

  void _onTap(int index) {
    if (pageController != null && pageController!.hasClients) {
      pageController!.animateToPage(
        index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildContent(BuildContext context, double currentPage) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final divider = theme.dividerColor;
    final pill = theme.colorScheme.primaryContainer;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabCount = _items.length;
              final tabWidth = constraints.maxWidth / tabCount;
              const pillWidth = 56.0;
              const pillHeight = 30.0;
              const pillTop = 8.0;

              final clampedPage = currentPage.clamp(
                0.0,
                (tabCount - 1).toDouble(),
              );
              final pillLeft =
                  clampedPage * tabWidth + (tabWidth - pillWidth) / 2;

              return Stack(
                children: [
                  Positioned(
                    left: pillLeft,
                    top: pillTop,
                    width: pillWidth,
                    height: pillHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: pill,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < tabCount; i++)
                        Expanded(
                          child: _NavButton(
                            item: _items[i],
                            progress: (1.0 - (clampedPage - i).abs()).clamp(
                              0.0,
                              1.0,
                            ),
                            selected: i == navigationShell.currentIndex,
                            onTap: () => _onTap(i),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = pageController;
    if (controller == null) {
      return _buildContent(context, navigationShell.currentIndex.toDouble());
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final currentPage = (controller.hasClients && controller.page != null)
            ? controller.page!
            : navigationShell.currentIndex.toDouble();
        return _buildContent(context, currentPage);
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.progress,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final double progress;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = theme.colorScheme.onSurface;
    final muted =
        theme.textTheme.bodySmall?.color ??
        (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final iconColor = Color.lerp(muted, ink, progress) ?? ink;
    final textColor = Color.lerp(muted, ink, progress) ?? ink;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              height: 30,
              child: Icon(
                progress > 0.5 ? item.activeIcon : item.icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: progress > 0.5 ? FontWeight.w600 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
