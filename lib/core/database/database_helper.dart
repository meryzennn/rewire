import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'tables.dart';

/// Every table name (spec §2.4), used by [clearAllData] for a full reset.
const List<String> kTableNames = [
  'user_profile',
  'daily_checkins',
  'triggers',
  'meditation_sessions',
  'workout_sessions',
  'quests',
  'achievements',
  'streaks',
];

/// Deletes every row from every table on [db], leaving the schema intact.
/// Used by the settings "Reset Semua Data" flow and testable against any
/// [Database] (e.g. an in-memory one).
Future<void> clearAllData(Database db) async {
  final batch = db.batch();
  for (final table in kTableNames) {
    batch.delete(table);
  }
  await batch.commit(noResult: true);
}

/// Singleton access to the on-device SQLite database.
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _databaseName = 'rewire.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final statement in kCreateTableStatements) {
      batch.execute(statement);
    }
    await batch.commit(noResult: true);
  }

  /// Wipes all local data (spec §2.4 tables), keeping the schema. Backs the
  /// settings reset; SharedPreferences are cleared separately by the caller.
  Future<void> resetData() async => clearAllData(await database);
}
