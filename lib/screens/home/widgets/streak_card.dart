import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/checkin_provider.dart';

/// Stitch home screen streak card widget: displays current and longest streaks,
/// along with daily check-in call to action.
class StreakCard extends StatelessWidget {
  const StreakCard({super.key, this.provider, this.onCheckinTap});

  final CheckinProvider? provider;

  /// Optional override for check-in action (useful for tests or custom navigators).
  final VoidCallback? onCheckinTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final checkinProvider = provider ?? context.watch<CheckinProvider>();

    final currentStreak = checkinProvider.currentStreak;
    final longestStreak = checkinProvider.longestStreak;
    final todayCheckin = checkinProvider.todayCheckin;
    final hasCheckedIn = todayCheckin != null;
    final isClean = todayCheckin?.status == 'clean';

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor =
        isDark ? AppColors.darkDivider : AppColors.divider;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.primary;
    final primaryContainer =
        isDark ? AppColors.darkPrimaryContainer : AppColors.primaryContainer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Fire icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '🔥',
              style: TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          // Streak count & longest streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'STREAK',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$currentStreak Hari',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Terpanjang: $longestStreak hari',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action button
          if (!hasCheckedIn)
            FilledButton.icon(
              onPressed: onCheckinTap ?? () => context.push(Routes.checkin),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text(
                'Check-in',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            )
          else
            Material(
              color: isClean ? primaryContainer : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onCheckinTap ?? () => context.push(Routes.checkin),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isClean ? Icons.check_circle : Icons.autorenew,
                        size: 16,
                        color: isClean ? primaryColor : textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isClean ? 'Selesai ✓' : 'Tercatat',
                        style: TextStyle(
                          color: isClean ? primaryColor : textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
