import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/quest.dart';

/// Weekly challenges card list widget (spec §3.4, §9).
class WeeklyChallenges extends StatelessWidget {
  const WeeklyChallenges({super.key, required this.challenges});

  final List<Quest> challenges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final surfaceVariant = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    final completedCount = challenges.where((q) => q.completed == 1).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tantangan Mingguan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$completedCount/${challenges.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (challenges.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dividerColor),
            ),
            child: Center(
              child: Text(
                'Tidak ada tantangan mingguan aktif',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                ),
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dividerColor),
            ),
            child: Column(
              children: List.generate(challenges.length, (index) {
                final quest = challenges[index];
                final isDone = quest.completed == 1;
                final progress = quest.targetValue > 0
                    ? (quest.currentValue / quest.targetValue).clamp(0.0, 1.0)
                    : 0.0;
                final isLast = index == challenges.length - 1;

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox icon
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: isDone ? primaryColor : surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDone ? primaryColor : dividerColor,
                            ),
                          ),
                          child: isDone
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // Title and progress
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      quest.title,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                            decoration: isDone
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+${quest.xpReward} XP',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.amber.shade300
                                            : AppColors.warning,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: surfaceVariant,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              primaryColor,
                                            ),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${quest.currentValue}/${quest.targetValue}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: dividerColor, height: 1),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}
