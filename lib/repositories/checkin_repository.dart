import 'package:sqflite/sqflite.dart';

import '../core/utils/date_utils.dart';
import '../models/daily_checkin.dart';
import '../models/streak.dart';

// ponytail: daily_checkins, triggers, and streaks share this repository because
// the plan defines no separate trigger/streak repository. Split into their own
// files if either grows its own query surface.
/// Check-ins (one row per local date), their triggers, and streak history.
class CheckinRepository {
  CheckinRepository(this._db);

  final Database _db;

  Future<DailyCheckin?> getByDate(DateTime date) =>
      _byDateString(formatLocalDate(date));

  Future<bool> hasCheckin(DateTime date) async =>
      (await getByDate(date)) != null;

  Future<List<DailyCheckin>> getHistory({int? limit}) async {
    final rows = await _db.query(
      'daily_checkins',
      orderBy: 'date DESC',
      limit: limit,
    );
    return rows.map(DailyCheckin.fromMap).toList();
  }

  Future<int> countByStatus(String status) async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          'SELECT COUNT(*) FROM daily_checkins WHERE status = ?',
          [status],
        ),
      ) ??
      0;

  Future<void> _upsertRow(
    DatabaseExecutor executor,
    DailyCheckin checkin,
  ) async {
    final values = <String, Object?>{
      'date': checkin.date,
      'status': checkin.status,
      'mood': checkin.mood,
      'notes': checkin.notes,
      'xp_earned': checkin.xpEarned,
    };
    final existing = await executor.query(
      'daily_checkins',
      columns: ['id'],
      where: 'date = ?',
      whereArgs: [checkin.date],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await executor.update(
        'daily_checkins',
        values,
        where: 'date = ?',
        whereArgs: [checkin.date],
      );
    } else {
      await executor.insert('daily_checkins', values);
    }
  }

  /// Inserts or updates the single check-in for its local date.
  Future<DailyCheckin> upsertCheckin(DailyCheckin checkin) async {
    await _upsertRow(_db, checkin);
    return (await _byDateString(checkin.date))!;
  }

  /// Saves the check-in and its triggers atomically; either all persist or none.
  Future<DailyCheckin> saveCheckin(
    DailyCheckin checkin, {
    List<String> triggers = const [],
  }) {
    return _db.transaction((txn) async {
      await txn.delete(
        'triggers',
        where: 'date = ?',
        whereArgs: [checkin.date],
      );
      for (final description in triggers) {
        await txn.insert('triggers', {
          'date': checkin.date,
          'description': description,
        });
      }
      await _upsertRow(txn, checkin);
      final row = (await txn.query(
        'daily_checkins',
        where: 'date = ?',
        whereArgs: [checkin.date],
        limit: 1,
      )).first;
      return DailyCheckin.fromMap(row);
    });
  }

  Future<List<String>> getTriggersByDate(String date) async {
    final rows = await _db.query(
      'triggers',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'id ASC',
    );
    return rows.map((r) => r['description'] as String).toList();
  }

  Future<int> triggerCount() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM triggers'),
      ) ??
      0;

  Future<int> insertStreak(Streak streak) => _db.insert('streaks', {
    'start_date': streak.startDate,
    'end_date': streak.endDate,
    'length': streak.length,
    'ended_by': streak.endedBy,
  });

  Future<List<Streak>> getStreaks({int? limit}) async {
    final rows = await _db.query(
      'streaks',
      orderBy: 'start_date DESC',
      limit: limit,
    );
    return rows.map(Streak.fromMap).toList();
  }

  Future<DailyCheckin?> _byDateString(String date) async {
    final rows = await _db.query(
      'daily_checkins',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    return rows.isEmpty ? null : DailyCheckin.fromMap(rows.first);
  }
}
