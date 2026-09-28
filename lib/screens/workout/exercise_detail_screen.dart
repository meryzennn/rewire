import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/health_utils.dart';
import '../../core/utils/l10n_utils.dart';
import '../../core/utils/provider_utils.dart';
import '../../core/utils/workout_safety_utils.dart';
import '../../data/exercises.dart';
import '../../data/routines.dart';
import '../../services/preference_service.dart';

/// Screen displaying detailed exercise instructions, form guide, and target muscles (spec §5b).
class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.preferences,
  });

  final Exercise exercise;
  final PreferenceService? preferences;

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
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final langCode = getAppLanguageCode(context);

    final exerciseDetails = getLocalizedExerciseDetails(
      exercise.id,
      exercise.targetMuscles,
      exercise.description,
      langCode,
    );
    final categoryLabel = getLocalizedCategory(exercise.category, langCode);
    final difficultyLabel = getLocalizedDifficulty(
      exercise.difficulty,
      langCode,
    );
    final unitLabel = getLocalizedExerciseUnit(exercise.unit, langCode);

    final prefs = preferences ?? context.readOrNull<PreferenceService>();
    final fitnessLevel = prefs?.userFitnessLevel ?? 'beginner';
    final bmi = calculateBmi(prefs?.userHeight, prefs?.userWeight);
    final isContraindicated = isExerciseContraindicated(
      exercise.id,
      fitnessLevel: fitnessLevel,
      bmi: bmi,
    );

    final altExerciseId = isContraindicated
        ? getSafeAlternativeExerciseId(exercise.id)
        : null;
    final altExercise = altExerciseId != null
        ? kAllExercises.firstWhere(
            (e) => e.id == altExerciseId,
            orElse: () => exercise,
          )
        : null;

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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/workout');
            }
          },
        ),
        title: Text(
          exercise.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Illustration / Visual Container
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: dividerColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fallback icon visual
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconForCategory(exercise.category),
                        size: 72,
                        color: accent.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exercise.category,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // Asset image if present
                  Image.asset(
                    exercise.imageAssetPath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title and badges
            Text(
              exercise.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildBadge(
                  label: categoryLabel,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  label: difficultyLabel,
                  color: accent,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  label: exercise.isTimed
                      ? (l10n?.timeBadge ?? 'Waktu')
                      : (l10n?.repsShort ?? 'Repetisi'),
                  color: isDark ? AppColors.darkSecondary : AppColors.secondary,
                  isDark: isDark,
                ),
              ],
            ),
            if (isContraindicated)
              _buildJointSafetyBanner(
                context: context,
                l10n: l10n,
                langCode: langCode,
                alternativeExercise: altExercise,
                isDark: isDark,
              ),
            const SizedBox(height: 20),

            // Target Sets & Reps Info Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.targetSet ?? 'Target Set',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n?.setsCount(exercise.defaultSets) ??
                              '${exercise.defaultSets} Set',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.isTimed
                              ? (l10n?.durationPerSet ?? 'Durasi / Set')
                              : (l10n?.targetPerSet ?? 'Target / Set'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${exercise.defaultReps} $unitLabel',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Target Muscles Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
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
                    child: Icon(Icons.accessibility, color: accent, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.targetMusclesTitle ?? 'Target Otot Utama',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          exerciseDetails.$1,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instructions Section
            Text(
              l10n?.instructionsTitle ?? 'Instruksi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
              ),
              child: Text(
                exerciseDetails.$2,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tips card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    (isDark
                            ? AppColors.darkPrimaryContainer
                            : AppColors.primaryContainer)
                        .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.recoveryTipsTitle ?? 'Tips Pemulihan & Postur',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n?.recoveryTipsContent ??
                              'Fokus pada pernapasan teratur dan kendalikan setiap repetisi. Gerakan lambat dan presisi lebih efektif mengaktifkan jalur saraf positif dibanding kecepatan.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: ElevatedButton.icon(
            key: const Key('exercise-detail-start-button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 24),
            label: Text(
              l10n?.startThisExercise ?? 'Mulai Latihan Ini',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              final singleRoutine = WorkoutRoutine(
                id: 'single_${exercise.id}',
                name: exercise.name,
                subtitle: categoryLabel,
                durationMinutes: 5,
                difficulty: exercise.difficulty,
                exerciseIds: [exercise.id],
                description: exerciseDetails.$2,
              );

              if (isContraindicated) {
                _showSafetyConfirmationDialog(
                  context: context,
                  l10n: l10n,
                  langCode: langCode,
                  singleRoutine: singleRoutine,
                  alternativeExercise: altExercise,
                );
              } else {
                context.push(Routes.activeWorkout, extra: singleRoutine);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildJointSafetyBanner({
    required BuildContext context,
    required AppLocalizations? l10n,
    required String langCode,
    required Exercise? alternativeExercise,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final (warningTitle, warningDesc) = getLocalizedSafetyWarning(
      exercise.id,
      langCode,
    );
    final warningColor = isDark ? const Color(0xFFFBBF24) : AppColors.warning;

    return Container(
      key: const Key('banner-joint-safety'),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: warningColor.withValues(alpha: isDark ? 0.4 : 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: warningColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  warningTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            warningDesc,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          if (alternativeExercise != null) ...[
            const SizedBox(height: 12),
            InkWell(
              key: const Key('btn-switch-alternative'),
              onTap: () {
                context.push(
                  Routes.exerciseDetail,
                  extra: alternativeExercise,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: warningColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 16,
                      color: warningColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n?.recommendedAlternativeLabel ?? 'Alternatif Direkomendasikan'}: ',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      alternativeExercise.name,
                      key: const Key('text-safe-alternative'),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: warningColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSafetyConfirmationDialog({
    required BuildContext context,
    required AppLocalizations? l10n,
    required String langCode,
    required WorkoutRoutine singleRoutine,
    required Exercise? alternativeExercise,
  }) {
    final (warningTitle, warningDesc) = getLocalizedSafetyWarning(
      exercise.id,
      langCode,
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n?.jointSafetyWarningTitle ?? warningTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              warningDesc,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            if (alternativeExercise != null) ...[
              const SizedBox(height: 14),
              Text(
                '${l10n?.recommendedAlternativeLabel ?? 'Alternatif'}: ${alternativeExercise.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            key: const Key('btn-proceed-anyway'),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.push(Routes.activeWorkout, extra: singleRoutine);
            },
            child: Text(
              l10n?.proceedAnyway ?? 'Tetap Lanjutkan',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          if (alternativeExercise != null)
            FilledButton(
              key: const Key('btn-use-safe-alternative'),
              onPressed: () {
                Navigator.pop(dialogCtx);
                final altRoutine = WorkoutRoutine(
                  id: 'single_${alternativeExercise.id}',
                  name: alternativeExercise.name,
                  subtitle: getLocalizedCategory(
                    alternativeExercise.category,
                    langCode,
                  ),
                  durationMinutes: 5,
                  difficulty: alternativeExercise.difficulty,
                  exerciseIds: [alternativeExercise.id],
                  description: alternativeExercise.description,
                );
                context.push(Routes.activeWorkout, extra: altRoutine);
              },
              child: Text(
                l10n?.useSafeAlternative ?? 'Gunakan Alternatif Aman',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
