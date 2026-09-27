import 'package:sqflite/sqflite.dart';

import '../models/quest.dart';

/// Assigned daily/weekly quests, their progress, and completion totals.
class QuestRepository {
  QuestRepository(this._db);

  final Database _db;

  /// Inserts the quests assigned for a refresh (daily set or weekly set).
  Future<void> insertQuests(List<Quest> quests) async {
    final batch = _db.batch();
    for (final q in quests) {
      batch.insert('quests', {
        'quest_id': q.questId,
        'type': q.type,
        'title': q.title,
        'description': q.description,
        'xp_reward': q.xpReward,
        'target_value': q.targetValue,
        'current_value': q.currentValue,
        'completed': q.completed,
        'date_assigned': q.dateAssigned,
        'date_completed': q.dateCompleted,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Quest>> getQuestsForDate(
    String dateAssigned, {
    String? type,
  }) async {
    final rows = await _db.query(
      'quests',
      where: type == null
          ? 'date_assigned = ?'
          : 'date_assigned = ? AND type = ?',
      whereArgs: type == null ? [dateAssigned] : [dateAssigned, type],
      orderBy: 'id ASC',
    );
    return rows.map(Quest.fromMap).toList();
  }

  /// Updates progress/completion for one quest row (requires [Quest.id]).
  Future<void> updateQuest(Quest quest) async {
    await _db.update(
      'quests',
      {
        'current_value': quest.currentValue,
        'completed': quest.completed,
        'date_completed': quest.dateCompleted,
      },
      where: 'id = ?',
      whereArgs: [quest.id],
    );
  }

  Future<int> completedCount({String? type}) async =>
      Sqflite.firstIntValue(
        await _db.rawQuery(
          type == null
              ? 'SELECT COUNT(*) FROM quests WHERE completed = 1'
              : 'SELECT COUNT(*) FROM quests WHERE completed = 1 AND type = ?',
          type == null ? null : [type],
        ),
      ) ??
      0;
}
