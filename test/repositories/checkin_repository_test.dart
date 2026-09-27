import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/date_utils.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/streak.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'repository_test_db.dart';

void main() {
  late Database db;
  late CheckinRepository repo;

  final date = DateTime(2026, 9, 27);
  final dateStr = formatLocalDate(date);

  DailyCheckin checkin({
    String? on,
    String status = 'clean',
    int? mood,
    int xp = 20,
  }) => DailyCheckin(
    date: on ?? dateStr,
    status: status,
    mood: mood,
    xpEarned: xp,
  );

  setUp(() async {
    db = await openTestDatabase();
    repo = CheckinRepository(db);
  });

  tearDown(() async => db.close());

  test('upsertCheckin inserts, then updates the same local date', () async {
    final inserted = await repo.upsertCheckin(checkin(mood: 4));
    expect(inserted.id, isNotNull);
    expect(inserted.status, 'clean');
    expect(inserted.mood, 4);

    final updated = await repo.upsertCheckin(
      checkin(status: 'relapse', mood: 2, xp: 0),
    );
    expect(updated.status, 'relapse');
    expect(updated.mood, 2);
    expect(updated.id, inserted.id, reason: 'same row, unique per date');

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM daily_checkins'),
    );
    expect(count, 1);
  });

  test('getByDate/hasCheckin match on the local calendar date', () async {
    expect(await repo.hasCheckin(date), isFalse);
    await repo.upsertCheckin(checkin());
    expect(await repo.hasCheckin(DateTime(2026, 9, 27, 23, 59)), isTrue);
    expect((await repo.getByDate(date))!.status, 'clean');
    expect(await repo.getByDate(DateTime(2026, 9, 28)), isNull);
  });

  test('countByStatus and getHistory reflect stored check-ins', () async {
    await repo.upsertCheckin(checkin(on: '2026-09-25', status: 'clean'));
    await repo.upsertCheckin(checkin(on: '2026-09-26', status: 'relapse'));
    await repo.upsertCheckin(checkin(on: '2026-09-27', status: 'clean'));

    expect(await repo.countByStatus('clean'), 2);
    expect(await repo.countByStatus('relapse'), 1);

    final history = await repo.getHistory();
    expect(history.map((c) => c.date).toList(), [
      '2026-09-27',
      '2026-09-26',
      '2026-09-25',
    ]);
  });

  test('saveCheckin persists check-in and triggers atomically', () async {
    final saved = await repo.saveCheckin(
      checkin(mood: 3),
      triggers: ['stress', 'boredom'],
    );
    expect(saved.mood, 3);
    expect(await repo.triggerCount(), 2);
    expect(await repo.getTriggersByDate(dateStr), ['stress', 'boredom']);

    // Re-saving with new triggers replaces previous triggers for this date
    await repo.saveCheckin(checkin(mood: 4), triggers: ['loneliness']);
    expect(await repo.triggerCount(), 1);
    expect(await repo.getTriggersByDate(dateStr), ['loneliness']);
  });

  test('saveCheckin rolls back triggers when the check-in fails', () async {
    await expectLater(
      repo.saveCheckin(
        checkin(status: 'invalid'), // violates status CHECK
        triggers: ['stress'],
      ),
      throwsA(isA<DatabaseException>()),
    );
    expect(await repo.triggerCount(), 0, reason: 'trigger insert rolled back');
    expect(await repo.getByDate(date), isNull);
  });

  test('insertStreak and getStreaks record streak history', () async {
    await repo.insertStreak(
      const Streak(
        startDate: '2026-09-01',
        endDate: '2026-09-08',
        length: 7,
        endedBy: 'relapse',
      ),
    );
    await repo.insertStreak(
      const Streak(startDate: '2026-09-09', length: 3, endedBy: 'active'),
    );
    final streaks = await repo.getStreaks();
    expect(streaks.map((s) => s.startDate).toList(), [
      '2026-09-09',
      '2026-09-01',
    ]);
    expect(streaks.first.endedBy, 'active');
  });
}
