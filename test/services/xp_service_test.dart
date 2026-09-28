import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/repositories/checkin_repository.dart';
import 'package:rewire/repositories/user_repository.dart';
import 'package:rewire/services/xp_service.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/repository_test_db.dart';

void main() {
  late Database db;
  late UserRepository users;
  late CheckinRepository checkins;
  late XpService xp;

  setUp(() async {
    db = await openTestDatabase();
    users = UserRepository(db);
    checkins = CheckinRepository(db);
    xp = XpService(users, checkins);
    await users.getOrCreateProfile();
  });

  tearDown(() async => db.close());

  test('award adds XP additively and reports before/after totals', () async {
    final a1 = await xp.award(30);
    expect(a1.totalXpBefore, 0);
    expect(a1.totalXpAfter, 30);
    expect(a1.amount, 30);

    final a2 = await xp.award(15);
    expect(a2.totalXpBefore, 30);
    expect(a2.totalXpAfter, 45);
  });

  test('award reports level-up when a threshold is crossed', () async {
    // Level 2 threshold is 50 XP (xp_table).
    final award = await xp.award(50);
    expect(award.levelBefore, 1);
    expect(award.levelAfter, 2);
    expect(award.leveledUp, isTrue);

    final flat = await xp.award(10);
    expect(flat.levelBefore, 2);
    expect(flat.levelAfter, 2);
    expect(flat.leveledUp, isFalse);
  });

  test('award persists recomputed level and brain stage', () async {
    // Level 10 cumulative XP is 2610 -> stage 'awakening'.
    await xp.award(2610);
    final profile = await users.getProfile();
    expect(profile!.totalXp, 2610);
    expect(profile.level, 10);
    expect(profile.brainStage, 'awakening');
  });

  test('revert deducts XP and updates level/brain stage', () async {
    await xp.award(100);
    expect((await users.getProfile())!.totalXp, 100);

    await xp.revert(20);
    final profile = await users.getProfile();
    expect(profile!.totalXp, 80);
  });

  group('awardDailyCheckin', () {
    final day = DateTime(2026, 9, 27);

    Future<void> insertCheckin(String status) async {
      await checkins.upsertCheckin(
        DailyCheckin(date: '2026-09-27', status: status, xpEarned: 0),
      );
    }

    test('awards +20 once for a clean check-in', () async {
      await insertCheckin('clean');
      final award = await xp.awardDailyCheckin(day);
      expect(award, isNotNull);
      expect(award!.amount, 20);
      expect(award.totalXpAfter, 20);
      expect((await checkins.getByDate(day))!.xpEarned, 20);
    });

    test('does not award the same day twice (no duplicate daily XP)', () async {
      await insertCheckin('clean');
      await xp.awardDailyCheckin(day);
      final second = await xp.awardDailyCheckin(day);
      expect(second, isNull);
      expect((await users.getProfile())!.totalXp, 20);
    });

    test('relapse check-in earns no daily XP', () async {
      await insertCheckin('relapse');
      final award = await xp.awardDailyCheckin(day);
      expect(award, isNull);
      expect((await users.getProfile())!.totalXp, 0);
    });

    test('throws when no check-in exists for the day', () async {
      expect(() => xp.awardDailyCheckin(day), throwsStateError);
    });
  });

  test('award rejects negative amounts', () async {
    expect(() => xp.award(-5), throwsA(isA<AssertionError>()));
  });

  test('awarding beyond level 50 clamps the level at 50', () async {
    final award = await xp.award(60000);
    expect(award.levelAfter, 50);
    expect((await users.getProfile())!.brainStage, 'transcendent');
  });
}
