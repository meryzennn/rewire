import '../core/utils/date_utils.dart';
import '../data/quests_definitions.dart';
import '../models/quest.dart';
import '../repositories/quest_repository.dart';
import 'xp_service.dart';

/// Activities that can advance quest progress. Shaped to what spec §3.4 tracks.
enum QuestActivity { checkin, meditation, workout, trigger, streak }

/// Assigns daily/weekly quests deterministically and advances their progress.
class QuestService {
  QuestService(this._quests, this._xp);

  final QuestRepository _quests;
  final XpService _xp;

  /// Ensures today has a daily set and, on Mondays, this week has a weekly set.
  ///
  /// Deterministic per date and idempotent per period: it never duplicates a
  /// set already assigned for today / this week.
  Future<void> refreshIfNeeded(DateTime now) async {
    final today = formatLocalDate(now);

    final existingDaily = await _quests.getQuestsForDate(today, type: 'daily');
    if (existingDaily.isEmpty) {
      await _quests.insertQuests(_selectDaily(now, today));
    }

    if (now.weekday == DateTime.monday) {
      final weekStart = today; // Monday is the week key
      final existingWeekly = await _quests.getQuestsForDate(
        weekStart,
        type: 'weekly',
      );
      if (existingWeekly.isEmpty) {
        await _quests.insertQuests(_selectWeekly(now, weekStart));
      }
    }
  }

  /// Returns all daily quests for [now] (refreshing if needed).
  Future<List<Quest>> getDailyQuests(DateTime now) async {
    await refreshIfNeeded(now);
    return _quests.getQuestsForDate(formatLocalDate(now), type: 'daily');
  }

  /// Returns all weekly quests for the week containing [now].
  Future<List<Quest>> getWeeklyQuests(DateTime now) async {
    final weekStart = formatLocalDate(_mondayOf(now));
    final existing = await _quests.getQuestsForDate(weekStart, type: 'weekly');
    if (existing.isEmpty) {
      await _quests.insertQuests(_selectWeekly(now, weekStart));
    }
    return _quests.getQuestsForDate(weekStart, type: 'weekly');
  }

  /// Advances every active quest that responds to [activity], marking newly
  /// completed quests done and awarding their XP once. Returns those newly
  /// completed quests.
  ///
  /// [amount] is minutes for meditation, a count for workouts/triggers, and the
  /// absolute current streak length for [QuestActivity.streak].
  Future<List<Quest>> recordActivity(
    QuestActivity activity,
    DateTime now, {
    int amount = 1,
  }) async {
    final today = formatLocalDate(now);
    final weekStart = formatLocalDate(_mondayOf(now));

    final active = [
      ...await _quests.getQuestsForDate(today, type: 'daily'),
      ...await _quests.getQuestsForDate(weekStart, type: 'weekly'),
    ];

    final newlyCompleted = <Quest>[];
    for (final quest in active) {
      if (quest.completed == 1) continue;
      final next = _advance(quest, activity, amount);
      if (next == null || next == quest.currentValue) continue;

      final done = next >= quest.targetValue;
      await _quests.updateQuest(
        Quest(
          id: quest.id,
          questId: quest.questId,
          type: quest.type,
          title: quest.title,
          description: quest.description,
          xpReward: quest.xpReward,
          targetValue: quest.targetValue,
          currentValue: next,
          completed: done ? 1 : 0,
          dateAssigned: quest.dateAssigned,
          dateCompleted: done ? today : null,
        ),
      );

      if (done) {
        await _xp.award(quest.xpReward);
        newlyCompleted.add(quest);
      }
    }
    return newlyCompleted;
  }

  /// Returns the new current value for [quest] given [activity], or null if the
  /// quest does not respond to it. Values are clamped to the target.
  int? _advance(Quest quest, QuestActivity activity, int amount) {
    final target = quest.targetValue;
    int inc(int by) => (quest.currentValue + by).clamp(0, target);

    switch (quest.questId) {
      case kCheckinQuestId:
        return activity == QuestActivity.checkin ? inc(1) : null;
      case 'meditate_5min':
        return activity == QuestActivity.meditation && amount >= 5
            ? target
            : null;
      case 'meditate_10min':
        return activity == QuestActivity.meditation && amount >= 10
            ? target
            : null;
      case 'workout_1':
      case 'workout_2':
        return activity == QuestActivity.workout ? inc(amount) : null;
      case 'log_trigger_1':
        return activity == QuestActivity.trigger ? inc(amount) : null;
      // ponytail: weekly meditation-day count approximates "5 hari" as 5
      // sessions; per-distinct-day counting needs a last-progress date it does
      // not store. Upgrade when the quest row can track distinct days.
      case 'weekly_meditate_5days':
        return activity == QuestActivity.meditation ? inc(1) : null;
      case 'weekly_meditate_30min':
        return activity == QuestActivity.meditation ? inc(amount) : null;
      case 'weekly_workout_3':
        return activity == QuestActivity.workout ? inc(amount) : null;
      case 'weekly_checkin_daily':
        return activity == QuestActivity.checkin ? inc(1) : null;
      case 'weekly_streak_7':
        // Streak length is absolute, not additive.
        return activity == QuestActivity.streak
            ? amount.clamp(0, target)
            : null;
      default:
        return null;
    }
  }

  // Deterministic selection keyed on the calendar date (no RNG), so the same
  // date always yields the same set and tests can assert it.
  // ponytail: rotation gives day-to-day variety; swap for a seeded RNG if the
  // product wants less predictable rotation.
  List<Quest> _selectDaily(DateTime now, String dateAssigned) {
    final seed = _dateSeed(now);
    final count = 3 + (seed % 2); // 3 or 4
    final others = kDailyQuestPool
        .where((t) => t.questId != kCheckinQuestId)
        .toList();
    final picked = _rotatePick(others, seed % others.length, count - 1);
    return [
      kDailyQuestPool.firstWhere((t) => t.questId == kCheckinQuestId),
      ...picked,
    ].map((t) => t.toQuest(dateAssigned)).toList();
  }

  List<Quest> _selectWeekly(DateTime now, String dateAssigned) {
    final seed = _dateSeed(now);
    final count = 2 + (seed % 2); // 2 or 3
    final picked = _rotatePick(
      kWeeklyQuestPool,
      seed % kWeeklyQuestPool.length,
      count,
    );
    return picked.map((t) => t.toQuest(dateAssigned)).toList();
  }

  List<QuestTemplate> _rotatePick(
    List<QuestTemplate> pool,
    int start,
    int count,
  ) => [for (var i = 0; i < count; i++) pool[(start + i) % pool.length]];

  int _dateSeed(DateTime d) => d.year * 372 + d.month * 31 + d.day;

  DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));
}
