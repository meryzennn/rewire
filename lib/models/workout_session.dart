class WorkoutSession {
  const WorkoutSession({
    this.id,
    required this.date,
    required this.routineId,
    required this.routineName,
    required this.durationSeconds,
    required this.exercisesCompleted,
    required this.exercisesTotal,
    required this.xpEarned,
    this.createdAt,
  });

  final int? id;
  final String date;
  final String routineId;
  final String routineName;
  final int durationSeconds;
  final int exercisesCompleted;
  final int exercisesTotal;
  final int xpEarned;
  final String? createdAt;

  factory WorkoutSession.fromMap(Map<String, Object?> map) => WorkoutSession(
    id: map['id'] as int?,
    date: map['date'] as String,
    routineId: map['routine_id'] as String,
    routineName: map['routine_name'] as String,
    durationSeconds: map['duration_seconds'] as int,
    exercisesCompleted: map['exercises_completed'] as int,
    exercisesTotal: map['exercises_total'] as int,
    xpEarned: map['xp_earned'] as int,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'date': date,
    'routine_id': routineId,
    'routine_name': routineName,
    'duration_seconds': durationSeconds,
    'exercises_completed': exercisesCompleted,
    'exercises_total': exercisesTotal,
    'xp_earned': xpEarned,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is WorkoutSession &&
      other.id == id &&
      other.date == date &&
      other.routineId == routineId &&
      other.routineName == routineName &&
      other.durationSeconds == durationSeconds &&
      other.exercisesCompleted == exercisesCompleted &&
      other.exercisesTotal == exercisesTotal &&
      other.xpEarned == xpEarned &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    date,
    routineId,
    routineName,
    durationSeconds,
    exercisesCompleted,
    exercisesTotal,
    xpEarned,
    createdAt,
  );
}
