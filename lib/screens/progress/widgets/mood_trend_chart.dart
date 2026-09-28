import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/l10n_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/daily_checkin.dart';

/// Line chart visualizing mood trends (1-5) over the past 7 days (spec §9, Screen 6).
class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({super.key, required this.checkins, this.now});

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

  static const List<String> _moodEmojis = ['', '😢', '😕', '😐', '🙂', '😄'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localeCode = getAppLanguageCode(context);
    final dayLabels = _dayLabelsFor(localeCode);

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.accent;

    final referenceDate = now ?? DateTime.now();

    // Map 7 days
    final days = List.generate(7, (i) {
      return referenceDate.subtract(Duration(days: 6 - i));
    });

    final checkinMap = {for (final c in checkins) c.date: c};

    final spots = <FlSpot>[];
    var hasAnyMood = false;

    for (var i = 0; i < 7; i++) {
      final dateStr = formatLocalDate(days[i]);
      final checkin = checkinMap[dateStr];
      if (checkin != null &&
          checkin.mood != null &&
          checkin.mood! >= 1 &&
          checkin.mood! <= 5) {
        spots.add(FlSpot(i.toDouble(), checkin.mood!.toDouble()));
        hasAnyMood = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.moodTrendTitle ?? 'Tren Suasana Hati',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(
              l10n?.scale1To5 ?? 'Skala 1 - 5',
              style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
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
              if (!hasAnyMood) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      l10n?.noMoodHistory ??
                          'Belum ada catatan suasana hati 7 hari terakhir',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 1,
                      maxY: 5,
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final moodVal = spot.y.round();
                              final emoji = (moodVal >= 1 && moodVal <= 5)
                                  ? _moodEmojis[moodVal]
                                  : '';
                              return LineTooltipItem(
                                '$emoji Mood: $moodVal/5',
                                TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 32,
                            getTitlesWidget: (val, meta) {
                              final m = val.toInt();
                              if (m < 1 || m > 5) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  _moodEmojis[m],
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
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
                                    color: isToday
                                        ? accentColor
                                        : textSecondary,
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
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: dividerColor.withValues(alpha: 0.5),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: dividerColor, width: 1),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: accentColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4.5,
                                color: surfaceColor,
                                strokeWidth: 2.5,
                                strokeColor: accentColor,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                accentColor.withValues(alpha: 0.25),
                                accentColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
