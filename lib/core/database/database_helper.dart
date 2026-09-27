import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'tables.dart';

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
}
