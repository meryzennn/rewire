import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../core/utils/date_utils.dart';
import '../models/daily_checkin.dart';
import '../models/streak.dart';
import '../models/user_profile.dart';
import '../repositories/checkin_repository.dart';
import '../repositories/user_repository.dart';
import '../services/achievement_service.dart';
import '../services/quest_service.dart';
import '../services/xp_service.dart';

/// Milestone bonus XP for streaks (§3.1).
int streakMilestoneXp(int streak) {
  switch (streak) {
    case 7:
      return 50;
    case 14:
      return 100;
    case 30:
      return 200;
    case 60:
      return 350;
    case 90:
      return 500;
    default:
      return 0;
  }
}

/// Root provider managing daily check-ins, streaks, and triggers.
class CheckinProvider extends ChangeNotifier {
  CheckinProvider(
    this._checkins,
    this._xp, {
    this.users,
    this.quests,
    this.achievements,
  });

  final CheckinRepository _checkins;
  final XpService _xp;
  final UserRepository? users;
  final QuestService? quests;
  final AchievementService? achievements;

  DailyCheckin? _todayCheckin;
  List<String> _todayTriggers = const [];
  int _currentStreak = 0;
  int _longestStreak = 0;
  bool _isLoading = false;

  DailyCheckin? get todayCheckin => _todayCheckin;
  List<String> get todayTriggers => _todayTriggers;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  bool get isLoading => _isLoading;
  bool get hasCheckedInToday => _todayCheckin != null;

  CheckinRepository get checkins => _checkins;
  XpService get xp => _xp;

  /// Loads today's checkin and user profile streaks.
  Future<void> loadToday({DateTime? now}) async {
    _isLoading = true;
    notifyListeners();

    final targetDate = now ?? DateTime.now();
    final dateStr = formatLocalDate(targetDate);
    _todayCheckin = await _checkins.getByDate(targetDate);
    _todayTriggers = await _checkins.getTriggersByDate(dateStr);

    final u = users;
    if (u != null) {
      final profile = await u.getOrCreateProfile();
      _currentStreak = profile.currentStreak;
      _longestStreak = profile.longestStreak;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Submits or updates daily checkin atomically, advances streaks, awards XP,
  /// records quest activity, and evaluates achievements.
  Future<DailyCheckin> submitCheckin({
    required String status,
    int? mood,
    String? notes,
    List<String> triggers = const [],
    DateTime? now,
  }) async {
    final targetDate = now ?? DateTime.now();
    final dateStr = formatLocalDate(targetDate);
    final existing = await _checkins.getByDate(targetDate);
    final isFirstToday = existing == null;
    final int xpEarned = status == 'clean' ? (existing?.xpEarned ?? 0) : 0;

    final checkinToSave = DailyCheckin(
      date: dateStr,
      status: status,
      mood: mood,
      notes: notes,
      xpEarned: xpEarned,
    );

    // Save checkin & triggers atomically
    final saved = await _checkins.saveCheckin(
      checkinToSave,
      triggers: triggers,
    );

    final u = users;
    if (u != null) {
      final profile = await u.getOrCreateProfile();

      if (status == 'clean') {
        int newStreak;
        String streakStart;

        if (isFirstToday) {
          final yesterday = targetDate.subtract(const Duration(days: 1));
          final yesterdayCheckin = await _checkins.getByDate(yesterday);

          if (yesterdayCheckin != null && yesterdayCheckin.status == 'clean') {
            newStreak = profile.currentStreak + 1;
            streakStart = profile.streakStartDate ?? formatLocalDate(yesterday);
          } else {
            if (profile.currentStreak > 0) {
              await _checkins.insertStreak(
                Streak(
                  startDate:
                      profile.streakStartDate ?? formatLocalDate(yesterday),
                  endDate: formatLocalDate(yesterday),
                  length: profile.currentStreak,
                  endedBy: 'relapse',
                ),
              );
            }
            newStreak = 1;
            streakStart = dateStr;
          }
        } else {
          if (existing.status == 'relapse') {
            newStreak = 1;
            streakStart = dateStr;
          } else {
            newStreak = profile.currentStreak;
            streakStart = profile.streakStartDate ?? dateStr;
          }
        }

        final newLongest = math.max(newStreak, profile.longestStreak);

        await u.updateProfile(
          UserProfile(
            id: profile.id,
            level: profile.level,
            totalXp: profile.totalXp,
            currentStreak: newStreak,
            longestStreak: newLongest,
            streakStartDate: streakStart,
            brainStage: profile.brainStage,
            createdAt: profile.createdAt,
          ),
        );

        await _checkins.insertStreak(
          Streak(startDate: streakStart, length: newStreak, endedBy: 'active'),
        );

        _currentStreak = newStreak;
        _longestStreak = newLongest;

        // Daily XP (+20): awardDailyCheckin ensures exactly once per calendar day
        if (saved.xpEarned == 0) {
          await _xp.awardDailyCheckin(targetDate);
          final milestone = streakMilestoneXp(newStreak);
          if (milestone > 0 && isFirstToday) {
            await _xp.award(milestone);
          }
        }

        // Quests
        final q = quests;
        if (q != null) {
          await q.recordActivity(QuestActivity.checkin, targetDate);
          if (triggers.isNotEmpty) {
            await q.recordActivity(
              QuestActivity.trigger,
              targetDate,
              amount: triggers.length,
            );
          }
          await q.recordActivity(
            QuestActivity.streak,
            targetDate,
            amount: newStreak,
          );
        }
      } else {
        // status == 'relapse'
        if (existing != null && existing.status == 'clean' && existing.xpEarned > 0) {
          await _xp.revert(existing.xpEarned);
        }

        final currentProfile = await u.getOrCreateProfile();
        if (currentProfile.currentStreak > 0) {
          await _checkins.insertStreak(
            Streak(
              startDate: currentProfile.streakStartDate ?? dateStr,
              endDate: dateStr,
              length: currentProfile.currentStreak,
              endedBy: 'relapse',
            ),
          );
        }

        // Reset streak to 0, preserve lifetime total_xp, level, and longestStreak
        await u.updateProfile(
          UserProfile(
            id: currentProfile.id,
            level: currentProfile.level,
            totalXp: currentProfile.totalXp,
            currentStreak: 0,
            longestStreak: currentProfile.longestStreak,
            streakStartDate: null,
            brainStage: currentProfile.brainStage,
            createdAt: currentProfile.createdAt,
          ),
        );

        _currentStreak = 0;
        _longestStreak = currentProfile.longestStreak;

        // Quests
        final q = quests;
        if (q != null) {
          await q.recordActivity(QuestActivity.checkin, targetDate);
          if (triggers.isNotEmpty) {
            await q.recordActivity(
              QuestActivity.trigger,
              targetDate,
              amount: triggers.length,
            );
          }
        }
      }
    }

    // Achievements
    final a = achievements;
    if (a != null) {
      await a.checkAndUnlock(now: targetDate);
    }

    _todayCheckin = await _checkins.getByDate(targetDate);
    _todayTriggers = triggers;
    notifyListeners();

    return _todayCheckin!;
  }
}
