import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/achievement.dart';
import 'package:rewire/repositories/achievement_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'repository_test_db.dart';

void main() {
  late Database db;
  late AchievementRepository repo;

  Achievement badge(String id, {int unlocked = 0}) => Achievement(
    badgeId: id,
    title: id,
    description: 'desc',
    icon: '🔥',
    unlocked: unlocked,
  );

  setUp(() async {
    db = await openTestDatabase();
    repo = AchievementRepository(db);
  });

  tearDown(() async => db.close());

  test('seedAll inserts definitions and is idempotent', () async {
    await repo.seedAll([badge('first_spark'), badge('week_warrior')]);
    expect(await repo.getAll(), hasLength(2));

    // Re-seeding must not duplicate or overwrite existing badges.
    await repo.unlock('first_spark', '2026-09-27');
    await repo.seedAll([badge('first_spark'), badge('week_warrior')]);

    expect(await repo.getAll(), hasLength(2));
    expect((await repo.getByBadgeId('first_spark'))!.unlocked, 1);
  });

  test('getByBadgeId returns null for unknown badge', () async {
    expect(await repo.getByBadgeId('nope'), isNull);
  });

  test('unlock flips a badge once and reports whether it changed', () async {
    await repo.seedAll([badge('lunar_cycle')]);

    expect(await repo.unlock('lunar_cycle', '2026-09-27'), isTrue);
    final unlocked = await repo.getByBadgeId('lunar_cycle');
    expect(unlocked!.unlocked, 1);
    expect(unlocked.dateUnlocked, '2026-09-27');

    // Second unlock is a no-op.
    expect(await repo.unlock('lunar_cycle', '2026-10-01'), isFalse);
    expect(
      (await repo.getByBadgeId('lunar_cycle'))!.dateUnlocked,
      '2026-09-27',
    );
  });
}
