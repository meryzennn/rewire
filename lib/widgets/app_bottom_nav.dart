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
/// so each tab keeps its own navigation stack (spec §2.3).
///
/// Design (DESIGN.md §4 Navigation): 64dp bar on the Clean Canvas surface, flat
/// (no shadow), separated from content by a hairline divider. The active tab is
/// marked by a Sage Whisper (primary-container) pill behind its filled icon plus
/// a heavier label; inactive tabs use outline icons in Warm Stone.
///
/// The sage brand cue lives in the indicator pill rather than tinting the icon
/// or label sage: Garden Sage on the surface is only ~2:1 contrast, so tinting
/// text/icons sage would fail WCAG AA. The pill is decorative and the icon/label
/// stay in high-contrast ink, keeping both the brand and R-25 satisfied.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
    // initialLocation:true re-taps a tab back to its branch root, matching the
    // familiar bottom-nav behaviour.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: _items[i],
                    selected: i == navigationShell.currentIndex,
                    onTap: () => _onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final pill = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.primaryContainer;

    final iconColor = selected ? ink : muted;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        // A round highlight keeps the 48dp touch/focus target legible without
        // stretching a rectangle across the whole cell.
        customBorder: const StadiumBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 56,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? pill : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                selected ? item.activeIcon : item.icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 4),
            // Labels stay in high-contrast ink in both states (Warm Stone at
            // 12sp is ~4.3:1, under WCAG AA). The inactive tab is dimmed by its
            // outline icon and lighter weight instead of a low-contrast label.
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
