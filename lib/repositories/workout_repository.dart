import 'package:sqflite/sqflite.dart';

import '../models/workout_session.dart';

/// Workout session history and completed-session totals.
class WorkoutRepository {
  WorkoutRepository(this._db);

  final Database _db;

  Future<int> insertSession(WorkoutSession session) =>
      _db.insert('workout_sessions', {
        'date': session.date,
        'routine_id': session.routineId,
        'routine_name': session.routineName,
        'duration_seconds': session.durationSeconds,
        'exercises_completed': session.exercisesCompleted,
        'exercises_total': session.exercisesTotal,
        'xp_earned': session.xpEarned,
      });

  Future<List<WorkoutSession>> getHistory({int? limit}) async {
    final rows = await _db.query(
      'workout_sessions',
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return rows.map(WorkoutSession.fromMap).toList();
  }

  Future<int> completedCount() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM workout_sessions'),
      ) ??
      0;

  Future<int> totalCompletedSeconds() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          'SELECT COALESCE(SUM(duration_seconds), 0) FROM workout_sessions',
        ),
      ) ??
      0;
}
