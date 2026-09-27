import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/quests_definitions.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:rewire/repositories/quest_repository.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:rewire/services/quest_service.dart';
import 'package:rewire/services/xp_service.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/repository_test_db.dart';

void main() {
  late Database db;
  late QuestRepository quests;
  late UserRepository users;
  late XpService xp;
  late QuestService service;

  // A guaranteed Monday and a mid-week day derived from it.
  final monday = DateTime(2026, 9, 27).subtract(
    Duration(days: DateTime(2026, 9, 27).weekday - 1),
  );
  final wednesday = monday.add(const Duration(days: 2));

  setUp(() async {
    db = await openTestDatabase();
    quests = QuestRepository(db);
    users = UserRepository(db);
    xp = XpService(users, CheckinRepository(db));
    service = QuestService(quests, xp);
    await users.getOrCreateProfile();
  });

  tearDown(() async => db.close());

  test('monday is actually a Monday (test fixture sanity)', () {
    expect(monday.weekday, DateTime.monday);
    expect(wednesday.weekday, isNot(DateTime.monday));
  });

  group('refreshIfNeeded — daily', () {
    test('always assigns a daily set including the check-in quest', () async {
      await service.refreshIfNeeded(wednesday);
      final daily = await quests.getQuestsForDate(
        _date(wednesday),
        type: 'daily',
      );
      expect(daily.length, inInclusiveRange(3, 4));
      expect(daily.map((q) => q.questId), contains(kCheckinQuestId));
    });

    test('is idempotent within the same day', () async {
      await service.refreshIfNeeded(wednesday);
      await service.refreshIfNeeded(wednesday);
      final daily = await quests.getQuestsForDate(
        _date(wednesday),
        type: 'daily',
      );
      expect(daily.length, inInclusiveRange(3, 4));
    });

    test('daily selection is deterministic for a given date', () async {
      await service.refreshIfNeeded(wednesday);
      final first = (await quests.getQuestsForDate(_date(wednesday)))
          .map((q) => q.questId)
          .toList();

      final db2 = await openTestDatabase();
      addTearDown(() async => db2.close());
      final service2 = QuestService(
        QuestRepository(db2),
        XpService(UserRepository(db2), CheckinRepository(db2)),
      );
      await service2.refreshIfNeeded(wednesday);
      final second = (await QuestRepository(db2).getQuestsForDate(_date(wednesday)))
          .map((q) => q.questId)
          .toList();

      expect(first, second);
    });
  });

  group('refreshIfNeeded — weekly', () {
    test('does not assign weekly quests on a non-Monday', () async {
      await service.refreshIfNeeded(wednesday);
      final weekly = await quests.getQuestsForDate(
        _date(wednesday),
        type: 'weekly',
      );
      expect(weekly, isEmpty);
    });

    test('assigns 2-3 weekly quests on Monday, idempotently', () async {
      await service.refreshIfNeeded(monday);
      await service.refreshIfNeeded(monday);
      final weekly = await quests.getQuestsForDate(_date(monday), type: 'weekly');
      expect(weekly.length, inInclusiveRange(2, 3));
    });
  });

  group('recordActivity', () {
    test('check-in completes the daily check-in quest and awards its XP once',
        () async {
      await service.refreshIfNeeded(wednesday);

      final completed = await service.recordActivity(
        QuestActivity.checkin,
        wednesday,
      );
      expect(completed.map((q) => q.questId), contains(kCheckinQuestId));
      expect((await users.getProfile())!.totalXp, kDailyQuestXp);

      // Recording again must not re-award an already completed quest.
      final again = await service.recordActivity(QuestActivity.checkin, wednesday);
      expect(again.map((q) => q.questId), isNot(contains(kCheckinQuestId)));
      expect((await users.getProfile())!.totalXp, kDailyQuestXp);
    });

    test('a 10-minute meditation completes both 5- and 10-minute quests',
        () async {
      // Force a full daily pool so both meditation quests are present.
      await quests.insertQuests([
        for (final t in kDailyQuestPool) t.toQuest(_date(wednesday)),
      ]);

      final completed = await service.recordActivity(
        QuestActivity.meditation,
        wednesday,
        amount: 10,
      );
      final ids = completed.map((q) => q.questId).toSet();
      expect(ids, containsAll({'meditate_5min', 'meditate_10min'}));
    });

    test('weekly meditation-minutes quest accumulates toward its target',
        () async {
      await service.refreshIfNeeded(monday); // assigns weekly for the week
      // Two 20-minute sessions => 40 >= 30 target for weekly_meditate_30min.
      await service.recordActivity(QuestActivity.meditation, monday, amount: 20);
      final done = await service.recordActivity(
        QuestActivity.meditation,
        monday,
        amount: 20,
      );
      // If the weekly minutes quest was assigned this week, it should complete.
      final weekly = await quests.getQuestsForDate(_date(monday), type: 'weekly');
      final minutesQuest =
          weekly.where((q) => q.questId == 'weekly_meditate_30min');
      if (minutesQuest.isNotEmpty) {
        expect(minutesQuest.single.completed, 1);
        expect(done.map((q) => q.questId), contains('weekly_meditate_30min'));
      }
    });
  });
}

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
