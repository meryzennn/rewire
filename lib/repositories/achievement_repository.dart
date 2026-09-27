import 'package:sqflite/sqflite.dart';

import '../models/achievement.dart';

/// Achievement badge catalog and one-time unlock state.
class AchievementRepository {
  AchievementRepository(this._db);

  final Database _db;

  /// Seeds badge definitions once; existing badge_ids are left untouched.
  Future<void> seedAll(List<Achievement> definitions) async {
    final batch = _db.batch();
    for (final a in definitions) {
      batch.insert('achievements', {
        'badge_id': a.badgeId,
        'title': a.title,
        'description': a.description,
        'icon': a.icon,
        'unlocked': a.unlocked,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Achievement>> getAll() async {
    final rows = await _db.query('achievements', orderBy: 'id ASC');
    return rows.map(Achievement.fromMap).toList();
  }

  Future<Achievement?> getByBadgeId(String badgeId) async {
    final rows = await _db.query(
      'achievements',
      where: 'badge_id = ?',
      whereArgs: [badgeId],
      limit: 1,
    );
    return rows.isEmpty ? null : Achievement.fromMap(rows.first);
  }

  /// Unlocks a badge once; returns true only when this call flips it unlocked.
  Future<bool> unlock(String badgeId, String dateUnlocked) async {
    final updated = await _db.update(
      'achievements',
      {'unlocked': 1, 'date_unlocked': dateUnlocked},
      where: 'badge_id = ? AND unlocked = 0',
      whereArgs: [badgeId],
    );
    return updated > 0;
  }
}
