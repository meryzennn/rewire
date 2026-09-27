import '../models/quest.dart';

/// Quest XP rewards (spec §3.1).
const int kDailyQuestXp = 25;
const int kWeeklyQuestXp = 100;

/// The daily check-in quest is always part of the daily set (spec §3.4).
const String kCheckinQuestId = 'checkin_today';

/// A quest template — the fixed definition of a quest before it is assigned to
/// a specific date. [Quest] itself carries per-assignment state (date/progress).
class QuestTemplate {
  const QuestTemplate({
    required this.questId,
    required this.type,
    required this.title,
    required this.xpReward,
    required this.targetValue,
    this.description,
  });

  final String questId;
  final String type;
  final String title;
  final int xpReward;
  final int targetValue;
  final String? description;

  Quest toQuest(String dateAssigned) => Quest(
    questId: questId,
    type: type,
    title: title,
    description: description,
    xpReward: xpReward,
    targetValue: targetValue,
    currentValue: 0,
    completed: 0,
    dateAssigned: dateAssigned,
  );
}

/// Daily quest pool (spec §3.4). Titles verbatim from the spec.
const List<QuestTemplate> kDailyQuestPool = [
  QuestTemplate(
    questId: kCheckinQuestId,
    type: 'daily',
    title: 'Check-in hari ini',
    xpReward: kDailyQuestXp,
    targetValue: 1,
  ),
  QuestTemplate(
    questId: 'meditate_5min',
    type: 'daily',
    title: 'Meditasi minimal 5 menit',
    xpReward: kDailyQuestXp,
    targetValue: 1,
  ),
  QuestTemplate(
    questId: 'workout_1',
    type: 'daily',
    title: 'Selesaikan 1 workout',
    xpReward: kDailyQuestXp,
    targetValue: 1,
  ),
  QuestTemplate(
    questId: 'log_trigger_1',
    type: 'daily',
    title: 'Catat 1 trigger',
    xpReward: kDailyQuestXp,
    targetValue: 1,
  ),
  QuestTemplate(
    questId: 'meditate_10min',
    type: 'daily',
    title: 'Meditasi 10 menit',
    xpReward: kDailyQuestXp,
    targetValue: 1,
  ),
  QuestTemplate(
    questId: 'workout_2',
    type: 'daily',
    title: 'Selesaikan 2 workout',
    xpReward: kDailyQuestXp,
    targetValue: 2,
  ),
];

/// Weekly challenge pool (spec §3.4). Titles verbatim from the spec.
const List<QuestTemplate> kWeeklyQuestPool = [
  QuestTemplate(
    questId: 'weekly_meditate_5days',
    type: 'weekly',
    title: 'Meditasi 5 hari minggu ini',
    xpReward: kWeeklyQuestXp,
    targetValue: 5,
  ),
  QuestTemplate(
    questId: 'weekly_workout_3',
    type: 'weekly',
    title: '3 workout minggu ini',
    xpReward: kWeeklyQuestXp,
    targetValue: 3,
  ),
  QuestTemplate(
    questId: 'weekly_streak_7',
    type: 'weekly',
    title: 'Streak 7 hari',
    xpReward: kWeeklyQuestXp,
    targetValue: 7,
  ),
  QuestTemplate(
    questId: 'weekly_meditate_30min',
    type: 'weekly',
    title: 'Total 30 menit meditasi',
    xpReward: kWeeklyQuestXp,
    targetValue: 30,
  ),
  QuestTemplate(
    questId: 'weekly_checkin_daily',
    type: 'weekly',
    title: 'Check-in setiap hari',
    xpReward: kWeeklyQuestXp,
    targetValue: 7,
  ),
];
