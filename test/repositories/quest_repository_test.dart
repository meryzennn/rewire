import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/repositories/quest_repository.dart';

import 'repository_test_db.dart';

import 'package:sqflite/sqflite.dart';

void main() {
  late Database db;
  late QuestRepository repo;

  Quest quest({
    String questId = 'checkin_today',
    String type = 'daily',
    String date = '2026-09-27',
    int completed = 0,
    int current = 0,
    int target = 1,
  }) => Quest(
    questId: questId,
    type: type,
    title: 'Check-in hari ini',
    xpReward: 25,
    targetValue: target,
    currentValue: current,
    completed: completed,
    dateAssigned: date,
  );

  setUp(() async {
    db = await openTestDatabase();
    repo = QuestRepository(db);
  });

  tearDown(() async => db.close());

  test('insertQuests then getQuestsForDate filters by date and type', () async {
    await repo.insertQuests([
      quest(questId: 'checkin_today'),
      quest(questId: 'meditate_5', target: 1),
      quest(questId: 'weekly_streak_7', type: 'weekly'),
      quest(questId: 'stale', date: '2026-09-26'),
    ]);

    final today = await repo.getQuestsForDate('2026-09-27');
    expect(today, hasLength(3));

    final daily = await repo.getQuestsForDate('2026-09-27', type: 'daily');
    expect(daily.map((q) => q.questId), ['checkin_today', 'meditate_5']);
  });

  test('updateQuest persists progress and completion', () async {
    await repo.insertQuests([quest(target: 2)]);
    final stored = (await repo.getQuestsForDate('2026-09-27')).single;

    await repo.updateQuest(
      Quest(
        id: stored.id,
        questId: stored.questId,
        type: stored.type,
        title: stored.title,
        xpReward: stored.xpReward,
        targetValue: stored.targetValue,
        currentValue: 2,
        completed: 1,
        dateAssigned: stored.dateAssigned,
        dateCompleted: '2026-09-27',
      ),
    );

    final reloaded = (await repo.getQuestsForDate('2026-09-27')).single;
    expect(reloaded.currentValue, 2);
    expect(reloaded.completed, 1);
    expect(reloaded.dateCompleted, '2026-09-27');
  });

  test('completedCount counts completed quests, optionally by type', () async {
    await repo.insertQuests([
      quest(questId: 'a', completed: 1),
      quest(questId: 'b', completed: 1),
      quest(questId: 'c', completed: 0),
      quest(questId: 'w', type: 'weekly', completed: 1),
    ]);

    expect(await repo.completedCount(), 3);
    expect(await repo.completedCount(type: 'daily'), 2);
    expect(await repo.completedCount(type: 'weekly'), 1);
  });
}
