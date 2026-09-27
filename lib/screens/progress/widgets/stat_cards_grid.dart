import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// 6-item Bento Stat Grid displaying core recovery aggregates (spec §9, Screen 6).
class StatCardsGrid extends StatelessWidget {
  const StatCardsGrid({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.cleanDays,
    required this.meditationMinutes,
    required this.workoutSessions,
    required this.totalXp,
  });

  final int currentStreak;
  final int longestStreak;
  final int cleanDays;
  final int meditationMinutes;
  final int workoutSessions;
  final int totalXp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final secondaryColor =
        isDark ? AppColors.darkSecondary : AppColors.secondary;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.accent;

    final cards = [
      {
        'title': 'Streak Saat Ini',
        'value': '$currentStreak Hari',
        'emoji': '🔥',
        'color': primaryColor,
      },
      {
        'title': 'Streak Terpanjang',
        'value': '$longestStreak Hari',
        'emoji': '⚡',
        'color': textPrimary,
      },
      {
        'title': 'Total Hari Clean',
        'value': '$cleanDays Hari',
        'emoji': '✨',
        'color': primaryColor,
      },
      {
        'title': 'Total Meditasi',
        'value': '$meditationMinutes Menit',
        'emoji': '🧘',
        'color': secondaryColor,
      },
      {
        'title': 'Total Workout',
        'value': '$workoutSessions Sesi',
        'emoji': '💪',
        'color': accentColor,
      },
      {
        'title': 'Total Akumulasi',
        'value': '$totalXp XP',
        'emoji': '⭐',
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistik Pikiran',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(
              'Pembaruan otomatis',
              style: theme.textTheme.bodySmall?.copyWith(
                color: textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          card['value'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: card['color'] as Color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        card['emoji'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['title'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
