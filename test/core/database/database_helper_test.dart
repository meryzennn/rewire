import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/database/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) async {
          for (final statement in kCreateTableStatements) {
            await db.execute(statement);
          }
        },
      ),
    );
  });

  tearDown(() async => db.close());

  Future<Set<String>> tableNames() async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    return rows.map((r) => r['name'] as String).toSet();
  }

  test('creates all eight tables', () async {
    final names = await tableNames();
    expect(
      names,
      containsAll(<String>[
        'user_profile',
        'daily_checkins',
        'triggers',
        'meditation_sessions',
        'workout_sessions',
        'quests',
        'achievements',
        'streaks',
      ]),
    );
  });

  test('daily_checkins.date is UNIQUE', () async {
    await db.insert('daily_checkins', {
      'date': '2026-09-27',
      'status': 'clean',
    });
    expect(
      () => db.insert('daily_checkins', {
        'date': '2026-09-27',
        'status': 'relapse',
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('daily_checkins.status CHECK rejects invalid values', () async {
    expect(
      () =>
          db.insert('daily_checkins', {'date': '2026-09-27', 'status': 'nope'}),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('daily_checkins.mood CHECK enforces 1..5', () async {
    expect(
      () => db.insert('daily_checkins', {
        'date': '2026-09-27',
        'status': 'clean',
        'mood': 6,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('quests.type CHECK rejects invalid values', () async {
    expect(
      () => db.insert('quests', {
        'quest_id': 'q1',
        'type': 'monthly',
        'title': 't',
        'xp_reward': 10,
        'date_assigned': '2026-09-27',
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('streaks.ended_by CHECK rejects invalid values', () async {
    expect(
      () => db.insert('streaks', {
        'start_date': '2026-09-01',
        'length': 5,
        'ended_by': 'bogus',
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('achievements.badge_id is UNIQUE', () async {
    await db.insert('achievements', {'badge_id': 'b1', 'title': 'One'});
    expect(
      () => db.insert('achievements', {'badge_id': 'b1', 'title': 'Two'}),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('defaults apply on insert', () async {
    final id = await db.rawInsert('INSERT INTO user_profile DEFAULT VALUES');
    final row = (await db.query(
      'user_profile',
      where: 'id = ?',
      whereArgs: [id],
    )).single;
    expect(row['level'], 1);
    expect(row['total_xp'], 0);
    expect(row['current_streak'], 0);
    expect(row['brain_stage'], 'dormant');
    expect(row['created_at'], isNotNull);

    final checkinId = await db.insert('daily_checkins', {
      'date': '2026-09-27',
      'status': 'clean',
    });
    final checkin = (await db.query(
      'daily_checkins',
      where: 'id = ?',
      whereArgs: [checkinId],
    )).single;
    expect(checkin['xp_earned'], 0);
    expect(checkin['created_at'], isNotNull);

    final medId = await db.insert('meditation_sessions', {
      'date': '2026-09-27',
      'duration_seconds': 300,
    });
    final med = (await db.query(
      'meditation_sessions',
      where: 'id = ?',
      whereArgs: [medId],
    )).single;
    expect(med['completed'], 1);
    expect(med['xp_earned'], 0);
  });
}
