import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../core/utils/date_utils.dart';
import '../core/utils/xp_utils.dart';
import '../models/daily_checkin.dart';
import '../models/user_profile.dart';
import '../repositories/checkin_repository.dart';
import '../repositories/user_repository.dart';

/// The +20 daily check-in reward (spec §3.1).
const int kDailyCheckinXp = 20;

/// Outcome of an XP award: enough for a level-up UI, nothing speculative.
class XpAward {
  const XpAward({
    required this.amount,
    required this.totalXpBefore,
    required this.totalXpAfter,
    required this.levelBefore,
    required this.levelAfter,
  });

  final int amount;
  final int totalXpBefore;
  final int totalXpAfter;
  final int levelBefore;
  final int levelAfter;

  bool get leveledUp => levelAfter > levelBefore;
}

/// Grants XP and keeps the profile's derived level/brain-stage in sync.
///
/// XP total is the source of truth (`total_xp`); level and brain stage are pure
/// functions of it, so they are recomputed and persisted on every award.
class XpService extends ChangeNotifier {
  XpService(this._users, this._checkins);

  final UserRepository _users;
  final CheckinRepository _checkins;

  /// Adds [amount] XP, recomputes level/stage, and reports before/after state.
  Future<XpAward> award(int amount) async {
    assert(amount >= 0, 'XP award amount must be non-negative');
    final before = await _users.getOrCreateProfile();
    final levelBefore = levelForXp(before.totalXp);

    final totalAfter = await _users.addXp(amount); // additive + transactional
    final levelAfter = levelForXp(totalAfter);
    final stageAfter = brainStageForLevel(levelAfter);

    if (totalAfter != before.totalXp ||
        levelAfter != before.level ||
        stageAfter != before.brainStage) {
      await _users.updateProfile(
        UserProfile(
          id: before.id,
          level: levelAfter,
          totalXp: totalAfter,
          currentStreak: before.currentStreak,
          longestStreak: before.longestStreak,
          streakStartDate: before.streakStartDate,
          brainStage: stageAfter,
          createdAt: before.createdAt,
        ),
      );
    }

    notifyListeners();

    return XpAward(
      amount: amount,
      totalXpBefore: before.totalXp,
      totalXpAfter: totalAfter,
      levelBefore: levelBefore,
      levelAfter: levelAfter,
    );
  }

  /// Deducts [amount] XP (e.g. when a clean check-in is revised to relapse),
  /// recomputes level/stage, and persists to profile.
  Future<void> revert(int amount) async {
    if (amount <= 0) return;
    final before = await _users.getOrCreateProfile();
    final totalAfter = math.max(0, before.totalXp - amount);
    final levelAfter = levelForXp(totalAfter);
    final stageAfter = brainStageForLevel(levelAfter);

    await _users.updateProfile(
      UserProfile(
        id: before.id,
        level: levelAfter,
        totalXp: totalAfter,
        currentStreak: before.currentStreak,
        longestStreak: before.longestStreak,
        streakStartDate: before.streakStartDate,
        brainStage: stageAfter,
        createdAt: before.createdAt,
      ),
    );

    notifyListeners();
  }

  /// Awards the daily +20 for a clean check-in, at most once per calendar day.
  ///
  /// Idempotency uses the check-in row's `xp_earned` as the marker, so a repeat
  /// call for the same day is a no-op (returns null). A relapse day earns 0.
  /// Requires the check-in for [day] to already exist (saved by the check-in flow).
  Future<XpAward?> awardDailyCheckin(DateTime day) async {
    final checkin = await _checkins.getByDate(day);
    if (checkin == null) {
      throw StateError(
        'Cannot award daily check-in XP: no check-in for ${formatLocalDate(day)}',
      );
    }
    if (checkin.status != 'clean') return null; // only clean days earn XP
    if (checkin.xpEarned > 0) return null; // already awarded today

    // Stamp the marker before granting XP so a crash cannot double-award.
    await _checkins.upsertCheckin(
      DailyCheckin(
        date: checkin.date,
        status: checkin.status,
        mood: checkin.mood,
        notes: checkin.notes,
        xpEarned: kDailyCheckinXp,
      ),
    );
    return award(kDailyCheckinXp);
  }
}
