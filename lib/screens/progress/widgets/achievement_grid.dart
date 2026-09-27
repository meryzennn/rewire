import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/achievement.dart';

/// Achievement grid widget displaying badge catalog and unlock states (spec §3.5, §9).
class AchievementGrid extends StatelessWidget {
  const AchievementGrid({
    super.key,
    required this.achievements,
  });

  final List<Achievement> achievements;

  void _showAchievementDetail(BuildContext context, Achievement achievement) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUnlocked = achievement.unlocked == 1;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(
              achievement.icon ?? '🏆',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                achievement.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.2)
                        : AppColors.primaryContainer)
                    : (isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock,
                    size: 16,
                    color: isUnlocked
                        ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary)
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isUnlocked
                        ? 'Terbuka${achievement.dateUnlocked != null ? ' (${achievement.dateUnlocked})' : ''}'
                        : 'Terkunci',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final surfaceVariant =
        isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    final unlockedCount = achievements.where((a) => a.unlocked == 1).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Pencapaian',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unlockedCount/${achievements.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: dividerColor),
          ),
          child: achievements.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Belum ada data pencapaian',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: achievements.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final a = achievements[index];
                    final isUnlocked = a.unlocked == 1;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showAchievementDetail(context, a),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isUnlocked
                                  ? (isDark
                                      ? AppColors.darkPrimaryContainer
                                      : AppColors.primaryContainer)
                                  : surfaceVariant,
                              border: Border.all(
                                color: isUnlocked
                                    ? primaryColor.withValues(alpha: 0.4)
                                    : dividerColor,
                              ),
                            ),
                            child: Center(
                              child: isUnlocked
                                  ? Text(
                                      a.icon ?? '🏆',
                                      style: const TextStyle(fontSize: 22),
                                    )
                                  : Icon(
                                      Icons.lock_outline,
                                      size: 20,
                                      color: textSecondary,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.title,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isUnlocked
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isUnlocked ? textPrimary : textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
