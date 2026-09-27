import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../data/routines.dart';
import '../../services/xp_service.dart';
import '../../widgets/celebration_overlay.dart';
import '../../widgets/xp_chip.dart';

/// Screen displayed upon completing a workout routine (spec §5e).
class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({
    super.key,
    required this.routine,
    required this.durationSeconds,
    required this.exercisesCompleted,
    required this.exercisesTotal,
    required this.xpAward,
  });

  final WorkoutRoutine routine;
  final int durationSeconds;
  final int exercisesCompleted;
  final int exercisesTotal;
  final XpAward xpAward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = theme.scaffoldBackgroundColor;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final accent = isDark ? AppColors.darkAccent : AppColors.accent;

    final durationMinutes = (durationSeconds / 60).round();
    final displayMinutes = durationMinutes > 0
        ? durationMinutes
        : routine.durationMinutes;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Celebration Confetti
          const Positioned.fill(child: CelebrationOverlay()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  // Icon badge
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: 0.15),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.fitness_center_rounded,
                        size: 50,
                        color: accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Headline
                  Text(
                    'Workout Selesai! 💪',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Routine Name
                  Text(
                    routine.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Duration and exercises completed text
                  Text(
                    '$displayMinutes menit · $exercisesCompleted gerakan selesai',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // XP Awarded chip
                  Center(child: XpChip(amount: xpAward.amount, fontSize: 16)),

                  if (xpAward.leveledUp) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: AppColors.warning, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Level Up! Kamu mencapai Level ${xpAward.levelAfter}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Completion Action Button
                  ElevatedButton(
                    key: const Key('workout-complete-done-button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.workout);
                      }
                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
