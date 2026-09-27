import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'repository_test_db.dart';

void main() {
  late Database db;
  late UserRepository repo;

  setUp(() async {
    db = await openTestDatabase();
    repo = UserRepository(db);
  });

  tearDown(() async => db.close());

  test('getProfile returns null before any row exists', () async {
    expect(await repo.getProfile(), isNull);
  });

  test('getOrCreateProfile inserts the default singleton row', () async {
    final profile = await repo.getOrCreateProfile();
    expect(profile.id, 1);
    expect(profile.level, 1);
    expect(profile.totalXp, 0);
    expect(profile.brainStage, 'dormant');

    // Idempotent: does not create a second row.
    await repo.getOrCreateProfile();
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_profile'),
    );
    expect(count, 1);
  });

  test('updateProfile persists mutable progression fields', () async {
    await repo.getOrCreateProfile();
    await repo.updateProfile(
      const UserProfile(
        level: 6,
        totalXp: 906,
        currentStreak: 7,
        longestStreak: 7,
        streakStartDate: '2026-09-20',
        brainStage: 'awakening',
      ),
    );
    final updated = await repo.getProfile();
    expect(updated!.level, 6);
    expect(updated.totalXp, 906);
    expect(updated.currentStreak, 7);
    expect(updated.streakStartDate, '2026-09-20');
    expect(updated.brainStage, 'awakening');
  });

  test('addXp is additive and returns the new total', () async {
    await repo.getOrCreateProfile();
    expect(await repo.addXp(20), 20);
    expect(await repo.addXp(15), 35);
    expect((await repo.getProfile())!.totalXp, 35);
  });
}
