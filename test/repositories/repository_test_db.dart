import 'package:rewire/core/database/tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Opens a fresh in-memory database with the full schema for repository tests.
Future<Database> openTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return databaseFactory.openDatabase(
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
}
