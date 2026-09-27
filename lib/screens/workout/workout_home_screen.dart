import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../data/exercises.dart';
import '../../data/routines.dart';
import '../../providers/user_provider.dart';
import '../../providers/workout_provider.dart';

/// The Workout home screen matching Stitch MCP screen f5fb3a15df3c46c49c1a3dbeb328a58c.
class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key, this.provider});

  final WorkoutProvider? provider;

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final prov = widget.provider ?? context.readOrNull<WorkoutProvider>();
        prov?.loadStats();
      }
    });
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'upper':
        return Icons.fitness_center;
      case 'lower':
        return Icons.accessibility_new;
      case 'core':
        return Icons.self_improvement;
      case 'cardio':
        return Icons.directions_run;
      default:
        return Icons.sports_gymnastics;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = theme.scaffoldBackgroundColor;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final surfaceVariant = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final accent = isDark ? AppColors.darkAccent : AppColors.accent;

    final workoutProv =
        context.watchOrNull<WorkoutProvider>() ?? widget.provider;
    final userProv = context.watchOrNull<UserProvider>();

    final selectedCategory = workoutProv?.selectedCategory ?? 'Semua';
    final totalSessions = workoutProv?.sessionCount ?? 0;
    final totalMinutes = workoutProv?.totalMinutes ?? 0;
    final userLevel = userProv?.profile?.level ?? 1;

    final filteredExercises = selectedCategory == 'Semua'
        ? kAllExercises
        : kAllExercises.where((e) => e.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology, color: accent, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Latihan',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: surfaceColor,
                        border: Border.all(color: dividerColor),
                      ),
                      child: Icon(Icons.tune, color: textSecondary, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Neuroplasticity Callout & Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    // Neuro-Rewire Boost Micro-Callout
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.bolt,
                                  color: accent,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Neuro-Rewire Boost',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                  ),
                                  Text(
                                    '+35 XP tiap sesi selesai',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Level $userLevel',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Stats row: Total Sesi and Total Menit
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: dividerColor),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.fitness_center,
                                    color: accent,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Sesi',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: textSecondary),
                                    ),
                                    Text(
                                      '$totalSessions',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: textPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: dividerColor),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.timer,
                                    color: accent,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Menit',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: textSecondary),
                                    ),
                                    Text(
                                      '$totalMinutes',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: textPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Section "Rutinitas"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rutinitas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      'Lihat Semua',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Routines Horizontal Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: kAllRoutines.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final routine = kAllRoutines[index];
                    return _buildRoutineCard(
                      context: context,
                      routine: routine,
                      surfaceColor: surfaceColor,
                      dividerColor: dividerColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      accent: accent,
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ),

            // 4. Section "Gerakan" & Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gerakan',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Semua', 'Upper', 'Lower', 'Core', 'Cardio']
                            .map((cat) {
                              final isSelected = selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    workoutProv?.setCategory(cat);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? accent
                                          : surfaceVariant,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : textSecondary,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Exercise List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final exercise = filteredExercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        context.push(Routes.exerciseDetail, extra: exercise);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Row(
                          children: [
                            // Exercise Icon / Image
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _iconForCategory(exercise.category),
                                color: accent,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${exercise.category} • ${exercise.targetMuscles}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              (isDark
                                                      ? AppColors
                                                            .darkPrimaryContainer
                                                      : AppColors
                                                            .primaryContainer)
                                                  .withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          exercise.difficulty,
                                          style: TextStyle(
                                            color: isDark
                                                ? AppColors.darkPrimary
                                                : AppColors.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '${exercise.defaultSets}×${exercise.defaultReps} ${exercise.unit}',
                                          style: TextStyle(
                                            color: textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Chevron button
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color: textSecondary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: filteredExercises.length),
              ),
            ),

            // Bottom padding for bottom navigation
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard({
    required BuildContext context,
    required WorkoutRoutine routine,
    required Color surfaceColor,
    required Color dividerColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accent,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      key: Key('routine-card-${routine.id}'),
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.push(Routes.activeWorkout, extra: routine);
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.darkPrimaryContainer
                                      : AppColors.primaryContainer)
                                  .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          routine.difficulty,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 14, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          '${routine.durationMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  routine.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  routine.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: dividerColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${routine.exerciseIds.length} Gerakan',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
