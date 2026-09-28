import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Quick recovery actions matching Stitch Home Screen section 5.
class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    this.onMeditationTap,
    this.onWorkoutTap,
    this.onStatsTap,
  });

  final VoidCallback? onMeditationTap;
  final VoidCallback? onWorkoutTap;
  final VoidCallback? onStatsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final primaryContainer = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.primaryContainer;
    final secondaryColor = isDark
        ? AppColors.darkSecondary
        : AppColors.secondary;
    final secondaryContainer = isDark
        ? AppColors.darkSecondaryContainer
        : AppColors.secondaryContainer;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.quickActionsTitle ?? 'Aksi Pemulihan',
            style: theme.textTheme.labelLarge?.copyWith(
              color: textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Action 1: Meditasi
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.self_improvement,
                  iconColor: primaryColor,
                  bgColor: primaryContainer,
                  label: l10n?.navMeditation ?? 'Meditasi',
                  textColor: textPrimary,
                  onTap: onMeditationTap ?? () => context.go(Routes.meditation),
                ),
              ),
              const SizedBox(width: 10),

              // Action 2: Workout
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.fitness_center,
                  iconColor: secondaryColor,
                  bgColor: secondaryContainer,
                  label: l10n?.navWorkout ?? 'Workout',
                  textColor: textPrimary,
                  onTap: onWorkoutTap ?? () => context.go(Routes.workout),
                ),
              ),
              const SizedBox(width: 10),

              // Action 3: Stats
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.insights,
                  iconColor: accentColor,
                  bgColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : const Color(0xFFD4EAE6),
                  label: l10n?.navProgress ?? 'Stats',
                  textColor: textPrimary,
                  onTap: onStatsTap ?? () => context.go(Routes.progress),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 24, color: iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
