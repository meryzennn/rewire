import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/daily_checkin.dart';

/// Bar chart visualizing check-in streak history over the past 7 days (spec §9, Screen 6).
class StreakChart extends StatelessWidget {
  const StreakChart({super.key, required this.checkins, this.now});

  final List<DailyCheckin> checkins;
  final DateTime? now;

  static List<String> _dayLabelsFor(String? localeCode) {
    switch (localeCode) {
      case 'en':
        return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'es':
        return const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      case 'ja':
        return const ['月', '火', '水', '木', '金', '土', '日'];
      case 'id':
      default:
        return const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localeCode = Localizations.maybeLocaleOf(context)?.languageCode;
    final dayLabels = _dayLabelsFor(localeCode);

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final dangerColor = AppColors.danger;

    final referenceDate = now ?? DateTime.now();

    // Map the last 7 calendar days up to today
    final days = List.generate(7, (i) {
      final d = referenceDate.subtract(Duration(days: 6 - i));
      return d;
    });

    final checkinMap = {for (final c in checkins) c.date: c};

    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < 7; i++) {
      final dateStr = formatLocalDate(days[i]);
      final checkin = checkinMap[dateStr];

      double height = 2.0;
      Color barColor = dividerColor.withValues(alpha: 0.5);

      if (checkin != null) {
        if (checkin.status == 'clean') {
          height = 10.0;
          barColor = primaryColor;
        } else {
          height = 4.0;
          barColor = dangerColor;
        }
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: height,
              color: barColor,
              width: 18,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.streakHistoryTitle ?? 'Streak History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(
              l10n?.last7Days ?? '7 Hari Terakhir',
              style: theme.textTheme.labelMedium?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: dividerColor),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 12,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final dateStr = formatLocalDate(days[group.x]);
                          final checkin = checkinMap[dateStr];
                          final statusText = checkin == null
                              ? (l10n?.noData ?? 'Tidak ada data')
                              : (checkin.status == 'clean'
                                    ? (l10n?.cleanTag ?? 'Bersih (Clean)')
                                    : (l10n?.relapseTag ?? 'Relapse'));
                          return BarTooltipItem(
                            '$dateStr\n$statusText',
                            TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx < 0 || idx >= 7) {
                              return const SizedBox.shrink();
                            }
                            final day = days[idx];
                            final label = dayLabels[day.weekday - 1];
                            final isToday = idx == 6;

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: isToday ? primaryColor : textSecondary,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: dividerColor, width: 1),
                      ),
                    ),
                    barGroups: barGroups,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Clean Day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dangerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Relapse Day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
