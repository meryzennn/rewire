import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/provider_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/quest.dart';
import '../../../providers/quest_provider.dart';
import '../../../widgets/xp_chip.dart';

/// Daily quests card matching Stitch Home Screen section 4.
class DailyQuestsCard extends StatelessWidget {
  const DailyQuestsCard({super.key, this.provider, this.quests});

  final QuestProvider? provider;
  final List<Quest>? quests;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final questList =
        quests ??
        provider?.dailyQuests ??
        context.watchOrNull<QuestProvider>()?.dailyQuests ??
        const [];

    final completedCount = questList.where((q) => q.completed == 1).length;
    final totalCount = questList.length;

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
    final itemBg = isDark
        ? AppColors.darkSurfaceVariant
        : const Color(0xFFF7F6F3);

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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.dailyQuestsTitle ?? 'Daily Quests',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$completedCount/$totalCount ✓',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quests List
          if (questList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tidak ada misi harian yang tersedia saat ini.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                ),
              ),
            )
          else
            ...questList.map((quest) {
              final isDone = quest.completed == 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: itemBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Checkbox / Circle
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isDone ? primaryColor : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isDone
                            ? null
                            : Border.all(
                                color: isDark
                                    ? AppColors.darkDivider
                                    : const Color(0xFFC3C8BE),
                                width: 2,
                              ),
                      ),
                      alignment: Alignment.center,
                      child: isDone
                          ? const Icon(
                              Icons.check,
                              size: 13,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),

                    // Quest Title
                    Expanded(
                      child: Text(
                        quest.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDone ? textSecondary : textPrimary,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: isDone
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // XP Reward Chip
                    XpChip(amount: quest.xpReward),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
