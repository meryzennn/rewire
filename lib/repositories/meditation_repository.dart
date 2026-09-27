import 'package:sqflite/sqflite.dart';

import '../models/meditation_session.dart';

/// Meditation session history and completed-session totals.
class MeditationRepository {
  MeditationRepository(this._db);

  final Database _db;

  Future<int> insertSession(MeditationSession session) =>
      _db.insert('meditation_sessions', {
        'date': session.date,
        'duration_seconds': session.durationSeconds,
        'audio_type': session.audioType,
        'breathing_type': session.breathingType,
        'xp_earned': session.xpEarned,
        'completed': session.completed,
      });

  Future<List<MeditationSession>> getHistory({int? limit}) async {
    final rows = await _db.query(
      'meditation_sessions',
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return rows.map(MeditationSession.fromMap).toList();
  }

  Future<int> totalCompletedSeconds() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          'SELECT COALESCE(SUM(duration_seconds), 0) '
          'FROM meditation_sessions WHERE completed = 1',
        ),
      ) ??
      0;

  Future<int> completedCount() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          'SELECT COUNT(*) FROM meditation_sessions WHERE completed = 1',
        ),
      ) ??
      0;
}
