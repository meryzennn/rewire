import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/database/database_helper.dart';
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
        onCreate: (db, version) async {
          for (final statement in kCreateTableStatements) {
            await db.execute(statement);
          }
        },
      ),
    );
  });

  tearDown(() async => db.close());

  Future<int> rowCount(String table) async {
    final rows = await db.rawQuery('SELECT COUNT(*) AS n FROM $table');
    return rows.first['n']! as int;
  }

  test('clearAllData empties every table but keeps the schema', () async {
    // Seed one row into each of the eight tables.
    await db.rawInsert('INSERT INTO user_profile (id) VALUES (1)');
    await db.insert('daily_checkins', {'date': '2026-09-27', 'status': 'clean'});
    await db.insert('triggers', {'date': '2026-09-27', 'description': 'x'});
    await db.insert('meditation_sessions', {
      'date': '2026-09-27',
      'duration_seconds': 300,
    });
    await db.insert('workout_sessions', {
      'date': '2026-09-27',
      'routine_id': 'r1',
      'routine_name': 'Morning',
      'duration_seconds': 600,
      'exercises_completed': 6,
      'exercises_total': 6,
    });
    await db.insert('quests', {
      'quest_id': 'q1',
      'type': 'daily',
      'title': 't',
      'xp_reward': 25,
      'date_assigned': '2026-09-27',
    });
    await db.insert('achievements', {'badge_id': 'b1', 'title': 'One'});
    await db.insert('streaks', {'start_date': '2026-09-01', 'length': 5});

    for (final table in kTableNames) {
      expect(await rowCount(table), greaterThan(0), reason: '$table seeded');
    }

    await clearAllData(db);

    for (final table in kTableNames) {
      expect(await rowCount(table), 0, reason: '$table cleared');
    }

    // Schema survives: a fresh insert still works after the wipe.
    await db.rawInsert('INSERT INTO user_profile (id) VALUES (1)');
    expect(await rowCount('user_profile'), 1);
  });
}
