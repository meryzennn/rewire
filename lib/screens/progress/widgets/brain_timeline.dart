import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/xp_utils.dart';

/// Brain evolution hero card and 5-stage timeline widget (spec §3.3, §9).
class BrainTimeline extends StatelessWidget {
  const BrainTimeline({
    super.key,
    required this.level,
    required this.totalXp,
    required this.brainStage,
  });

  final int level;
  final int totalXp;
  final String brainStage;

  static const List<Map<String, dynamic>> _stages = [
    {'id': 'dormant', 'name': 'Dormant', 'emoji': '🌑', 'range': 'Lvl 1-5'},
    {
      'id': 'awakening',
      'name': 'Awakening',
      'emoji': '🌱',
      'range': 'Lvl 6-15',
    },
    {'id': 'growing', 'name': 'Growing', 'emoji': '🌿', 'range': 'Lvl 16-25'},
    {'id': 'thriving', 'name': 'Thriving', 'emoji': '🌳', 'range': 'Lvl 26-40'},
    {
      'id': 'transcendent',
      'name': 'Transcendent',
      'emoji': '🧠',
      'range': 'Lvl 41-50',
    },
  ];

  int _stageIndex(String stage) {
    final idx = _stages.indexWhere((s) => s['id'] == stage.toLowerCase());
    return idx >= 0 ? idx : 0;
  }

  String _stageTitle(String stage) {
    switch (stage.toLowerCase()) {
      case 'dormant':
        return 'Dormant 🌑';
      case 'awakening':
        return 'Awakening 🌱';
      case 'growing':
        return 'Growing 🌿';
      case 'thriving':
        return 'Thriving 🌳';
      case 'transcendent':
        return 'Transcendent 🧠';
      default:
        return 'Dormant 🌑';
    }
  }

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
    final accent = isDark ? AppColors.darkAccent : AppColors.accent;

    final currentStageIdx = _stageIndex(brainStage);
    final inLevelXp = xpProgressInLevel(totalXp);
    final spanXp = xpSpanForLevel(level);
    final fraction = levelProgressFraction(totalXp);
    final remainingXp = (spanXp - inLevelXp).clamp(0, spanXp);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Brain stage visual icon & Level badge
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _stages[currentStageIdx]['emoji'] as String,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Level pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Level $level',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Stage title
          Text(
            _stageTitle(brainStage),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // XP Tracker Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: dividerColor),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pengalaman Jiwa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$inLevelXp / $spanXp XP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: fraction,
                    backgroundColor: surfaceColor,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  level < 50
                      ? '$remainingXp XP lagi menuju Level ${level + 1}'
                      : 'Level Maksimal Tercapai! 🌟',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5-Stage Horizontal Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stages.length, (idx) {
              final isCurrent = idx == currentStageIdx;
              final isPassed = idx < currentStageIdx;
              final stageData = _stages[idx];

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? primaryColor
                            : (isPassed
                                  ? primaryColor.withValues(alpha: 0.25)
                                  : surfaceVariant),
                        border: Border.all(
                          color: isCurrent
                              ? primaryColor
                              : (isPassed ? primaryColor : dividerColor),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isPassed
                            ? Icon(Icons.check, size: 16, color: primaryColor)
                            : (isCurrent
                                  ? const Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.lock,
                                      size: 14,
                                      color: textSecondary,
                                    )),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stageData['name'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrent ? accent : textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
