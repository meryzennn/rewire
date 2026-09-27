import '../core/utils/xp_utils.dart';
import 'exercises.dart';

/// Pre-made workout routines for Rewire (spec §4.2).
class WorkoutRoutine {
  const WorkoutRoutine({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.durationMinutes,
    required this.difficulty,
    required this.exerciseIds,
    required this.description,
  });

  final String id;
  final String name;
  final String subtitle;
  final int durationMinutes;
  final String difficulty; // 'Beginner' or 'Intermediate'
  final List<String> exerciseIds;
  final String description;

  /// Resolves the list of [Exercise] definitions belonging to this routine.
  List<Exercise> get exercises => exerciseIds
      .map((id) => findExerciseById(id))
      .whereType<Exercise>()
      .toList();

  /// Total XP awarded upon routine completion (spec §3.1).
  int get xp => xpForWorkoutDurationMinutes(durationMinutes);
}

/// The 3 canonical routines shipped in Rewire v1 (spec §4.2).
const List<WorkoutRoutine> kAllRoutines = [
  WorkoutRoutine(
    id: 'morning_energy',
    name: 'Morning Energy',
    subtitle: 'Aktivasi saraf & postur',
    durationMinutes: 15,
    difficulty: 'Beginner',
    exerciseIds: [
      'jumping_jack',
      'squat',
      'pushup',
      'lunge',
      'plank',
      'high_knees',
    ],
    description: 'Rutinitas pagi hari untuk membangunkan tubuh dan melancarkan sirkulasi energi.',
  ),
  WorkoutRoutine(
    id: 'full_body_burn',
    name: 'Full Body Burn',
    subtitle: 'Kekuatan & ketahanan',
    durationMinutes: 20,
    difficulty: 'Intermediate',
    exerciseIds: [
      'jumping_jack',
      'squat',
      'pushup',
      'mountain_climber',
      'lunge',
      'diamond_pushup',
      'burpee',
      'plank',
    ],
    description: 'Latihan seluruh tubuh intensitas menengah untuk membentuk kekuatan dan daya tahan.',
  ),
  WorkoutRoutine(
    id: 'core_crusher',
    name: 'Core Crusher',
    subtitle: 'Kekuatan otot inti',
    durationMinutes: 10,
    difficulty: 'Beginner',
    exerciseIds: [
      'plank',
      'crunch',
      'mountain_climber',
      'bicycle_crunch',
      'wall_sit',
    ],
    description: 'Latihan terfokus untuk memperkuat otot perut, pinggul, dan stabilitas postur.',
  ),
];

WorkoutRoutine? findRoutineById(String id) {
  for (final routine in kAllRoutines) {
    if (routine.id == id) return routine;
  }
  return null;
}
