import 'package:sqflite/sqflite.dart';

import '../models/user_profile.dart';

/// Reads and mutates the single `user_profile` row (id = 1).
class UserRepository {
  UserRepository(this._db);

  final Database _db;

  Future<UserProfile?> getProfile() async {
    final rows = await _db.query(
      'user_profile',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    return rows.isEmpty ? null : UserProfile.fromMap(rows.first);
  }

  /// Returns the profile, inserting the default row on first launch.
  Future<UserProfile> getOrCreateProfile() async {
    final existing = await getProfile();
    if (existing != null) return existing;
    await _db.rawInsert('INSERT INTO user_profile (id) VALUES (1)');
    return (await getProfile())!;
  }

  /// Persists the mutable progression fields; id and created_at are fixed.
  Future<void> updateProfile(UserProfile profile) async {
    await _db.update(
      'user_profile',
      {
        'level': profile.level,
        'total_xp': profile.totalXp,
        'current_streak': profile.currentStreak,
        'longest_streak': profile.longestStreak,
        'streak_start_date': profile.streakStartDate,
        'brain_stage': profile.brainStage,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  /// Adds [amount] to total_xp atomically and returns the new total.
  /// Level/brain-stage recompute belongs to XpService (Task 5).
  Future<int> addXp(int amount) {
    return _db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE user_profile SET total_xp = total_xp + ? WHERE id = 1',
        [amount],
      );
      return Sqflite.firstIntValue(
            await txn.rawQuery(
              'SELECT total_xp FROM user_profile WHERE id = 1',
            ),
          ) ??
          0;
    });
  }
}
