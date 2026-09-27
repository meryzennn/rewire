import 'package:sqflite/sqflite.dart';

import '../core/utils/date_utils.dart';
import '../models/daily_checkin.dart';
import '../models/streak.dart';

// ponytail: daily_checkins, triggers, and streaks share this repository because
// the plan defines no separate trigger/streak repository. Split into their own
// files if either grows its own query surface.
const String _upsertCheckinSql =
    'INSERT INTO daily_checkins (date, status, mood, notes, xp_earned) '
    'VALUES (?, ?, ?, ?, ?) '
    'ON CONFLICT(date) DO UPDATE SET '
    'status = excluded.status, mood = excluded.mood, '
    'notes = excluded.notes, xp_earned = excluded.xp_earned';

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

  /// Inserts or updates the single check-in for its local date.
  Future<DailyCheckin> upsertCheckin(DailyCheckin checkin) async {
    await _db.rawInsert(_upsertCheckinSql, _checkinArgs(checkin));
    return (await _byDateString(checkin.date))!;
  }

  /// Saves the check-in and its triggers atomically; either all persist or none.
  Future<DailyCheckin> saveCheckin(
    DailyCheckin checkin, {
    List<String> triggers = const [],
  }) {
    return _db.transaction((txn) async {
      for (final description in triggers) {
        await txn.insert('triggers', {
          'date': checkin.date,
          'description': description,
        });
      }
      await txn.rawInsert(_upsertCheckinSql, _checkinArgs(checkin));
      final row = (await txn.query(
        'daily_checkins',
        where: 'date = ?',
        whereArgs: [checkin.date],
        limit: 1,
      )).first;
      return DailyCheckin.fromMap(row);
    });
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

  List<Object?> _checkinArgs(DailyCheckin c) => [
    c.date,
    c.status,
    c.mood,
    c.notes,
    c.xpEarned,
  ];

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
