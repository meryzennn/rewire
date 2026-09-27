import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../data/exercises.dart';
import '../../data/routines.dart';
import '../../providers/workout_provider.dart';
import '../../services/xp_service.dart';
import 'rest_timer_screen.dart';
import 'workout_complete_screen.dart';

bool get _isTestEnvironment {
  if (kIsWeb) return false;
  return Platform.environment.containsKey('FLUTTER_TEST');
}

/// Screen tracking an active workout session step-by-step with sets and rest periods (spec §5c).
class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key, required this.routine, this.provider});

  final WorkoutRoutine routine;
  final WorkoutProvider? provider;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  bool _isResting = false;
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;

  // Timed exercise state
  late int _exerciseTimerSeconds;
  Timer? _exerciseCountdownTimer;
  bool _isExerciseTimerRunning = false;

  List<Exercise> get _exercises => widget.routine.exercises;
  Exercise get _currentExercise => _exercises[_currentExerciseIndex];

  bool get _isLastExercise => _currentExerciseIndex == _exercises.length - 1;
  bool get _isLastSetOfCurrentExercise =>
      _currentSet >= _currentExercise.defaultSets;
  bool get _isEntireWorkoutComplete =>
      _isLastExercise && _isLastSetOfCurrentExercise;

  @override
  void initState() {
    super.initState();
    _resetExerciseTimer();

    if (!_isTestEnvironment) {
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _elapsedSeconds++;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _exerciseCountdownTimer?.cancel();
    super.dispose();
  }

  void _resetExerciseTimer() {
    _exerciseCountdownTimer?.cancel();
    _isExerciseTimerRunning = false;
    _exerciseTimerSeconds = _currentExercise.isTimed
        ? _currentExercise.defaultReps
        : 0;
  }

  void _toggleExerciseTimer() {
    if (_isExerciseTimerRunning) {
      _exerciseCountdownTimer?.cancel();
      setState(() {
        _isExerciseTimerRunning = false;
      });
    } else {
      setState(() {
        _isExerciseTimerRunning = true;
      });
      if (!_isTestEnvironment) {
        _exerciseCountdownTimer = Timer.periodic(const Duration(seconds: 1), (
          timer,
        ) {
          if (!mounted) return;
          if (_exerciseTimerSeconds > 1) {
            setState(() {
              _exerciseTimerSeconds--;
            });
          } else {
            timer.cancel();
            setState(() {
              _exerciseTimerSeconds = 0;
              _isExerciseTimerRunning = false;
            });
          }
        });
      }
    }
  }

  Future<void> _completeSet() async {
    _exerciseCountdownTimer?.cancel();

    if (_isEntireWorkoutComplete) {
      await _finishWorkout();
    } else {
      // Enter rest period
      setState(() {
        _isResting = true;
      });
    }
  }

  void _onRestComplete() {
    setState(() {
      _isResting = false;
      if (_isLastSetOfCurrentExercise) {
        _currentExerciseIndex++;
        _currentSet = 1;
      } else {
        _currentSet++;
      }
      _resetExerciseTimer();
    });
  }

  Future<void> _finishWorkout() async {
    _sessionTimer?.cancel();
    _exerciseCountdownTimer?.cancel();

    final workoutProv =
        widget.provider ?? context.readOrNull<WorkoutProvider>();
    final effectiveDuration = _elapsedSeconds > 0
        ? _elapsedSeconds
        : widget.routine.durationMinutes * 60;

    final award =
        await workoutProv?.completeWorkout(
          routineId: widget.routine.id,
          routineName: widget.routine.name,
          durationSeconds: effectiveDuration,
          exercisesCompleted: _exercises.length,
          exercisesTotal: _exercises.length,
        ) ??
        await Future.value(null);

    if (!mounted) return;

    // Navigate to completion screen
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (ctx) => WorkoutCompleteScreen(
            routine: widget.routine,
            durationSeconds: effectiveDuration,
            exercisesCompleted: _exercises.length,
            exercisesTotal: _exercises.length,
            xpAward:
                award ??
                const XpAward(
                  amount: 25,
                  totalXpBefore: 0,
                  totalXpAfter: 25,
                  levelBefore: 1,
                  levelAfter: 1,
                ),
          ),
        ),
      );
    }
  }

  Future<void> _confirmCancel() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        title: const Text('Batalkan Latihan?'),
        content: const Text(
          'Progres sesi ini belum akan tersimpan jika kamu keluar sekarang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Lanjut Latihan'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (shouldCancel == true && mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(Routes.workout);
      }
    }
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

  String _getNextExerciseInfo() {
    if (!_isLastSetOfCurrentExercise) {
      return 'Set ${_currentSet + 1} / ${_currentExercise.defaultSets} (${_currentExercise.defaultReps} ${_currentExercise.unit})';
    }
    if (!_isLastExercise) {
      final nextEx = _exercises[_currentExerciseIndex + 1];
      return '${nextEx.name} • ${nextEx.defaultSets} × ${nextEx.defaultReps} ${nextEx.unit}';
    }
    return 'Latihan Terakhir!';
  }

  @override
  Widget build(BuildContext context) {
    if (_isResting) {
      final nextTitle = !_isLastSetOfCurrentExercise
          ? _currentExercise.name
          : (!_isLastExercise
                ? _exercises[_currentExerciseIndex + 1].name
                : 'Selesai');
      return RestTimerScreen(
        durationSeconds: 30,
        nextExerciseName: nextTitle,
        nextExerciseSetsReps: _getNextExerciseInfo(),
        onRestComplete: _onRestComplete,
      );
    }

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
    final accent = isDark ? AppColors.darkAccent : AppColors.accent;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;

    final progress =
        (_currentExerciseIndex +
            (_currentSet - 1) / _currentExercise.defaultSets) /
        _exercises.length;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.routine.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            key: const Key('active-workout-cancel-button'),
            onPressed: _confirmCancel,
            icon: Icon(Icons.close, color: textSecondary, size: 20),
            label: Text(
              'Batal',
              style: TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall Progress Bar & Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gerakan ${_currentExerciseIndex + 1} / ${_exercises.length}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),

              // Current Exercise Illustration / Fallback
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: dividerColor),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _iconForCategory(_currentExercise.category),
                            size: 80,
                            color: accent.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _currentExercise.category,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        _currentExercise.imageAssetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Exercise Title & Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dividerColor),
                ),
                child: Column(
                  children: [
                    Text(
                      _currentExercise.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Set $_currentSet / ${_currentExercise.defaultSets}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Reps or Timer
                    if (_currentExercise.isTimed) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_exerciseTimerSeconds Detik',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(
                              _isExerciseTimerRunning
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: accent,
                              size: 36,
                            ),
                            onPressed: _toggleExerciseTimer,
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        '${_currentExercise.defaultReps} ${_currentExercise.unit}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Next Exercise Label
              Center(
                child: Text(
                  'Next: ${_getNextExerciseInfo()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Action Button (Set Selesai)
              ElevatedButton(
                key: const Key('active-workout-complete-set-button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: _completeSet,
                child: Text(
                  _isEntireWorkoutComplete
                      ? 'Selesai Latihan ✓'
                      : 'Set Selesai ✓',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
