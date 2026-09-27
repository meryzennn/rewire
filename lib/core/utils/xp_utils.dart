import 'dart:math' as math;

import 'package:rewire/core/constants/xp_table.dart';

int xpToReach(int level) => xpTable[_clampLevel(level) - 1];

int levelForXp(int totalXp) {
  var low = 0;
  var high = xpTable.length - 1;
  while (low < high) {
    final mid = (low + high + 1) ~/ 2;
    if (totalXp >= xpTable[mid]) {
      low = mid;
    } else {
      high = mid - 1;
    }
  }
  return low + 1;
}

String brainStageForLevel(int level) {
  final clampedLevel = _clampLevel(level);
  if (clampedLevel <= 5) return 'dormant';
  if (clampedLevel <= 15) return 'awakening';
  if (clampedLevel <= 25) return 'growing';
  if (clampedLevel <= 40) return 'thriving';
  return 'transcendent';
}

int _clampLevel(int level) => math.max(1, math.min(50, level));

/// XP required to advance from [currentLevel] to [currentLevel + 1].
int xpSpanForLevel(int currentLevel) {
  final clamped = _clampLevel(currentLevel);
  if (clamped >= 50) return 1;
  return xpToReach(clamped + 1) - xpToReach(clamped);
}

/// XP accumulated within the current level bracket.
int xpProgressInLevel(int totalXp) {
  final level = levelForXp(totalXp);
  final currentThreshold = xpToReach(level);
  return totalXp - currentThreshold;
}

/// Progress ratio (0.0 to 1.0) towards the next level.
double levelProgressFraction(int totalXp) {
  final level = levelForXp(totalXp);
  if (level >= 50) return 1.0;
  final span = xpSpanForLevel(level);
  final inLevel = xpProgressInLevel(totalXp);
  return (inLevel / span).clamp(0.0, 1.0);
}

/// XP earned for a completed meditation session based on duration in minutes (spec §3.1).
/// 5min=10, 10min=15, 15min=20, 20min=25, 30min=30.
int xpForMeditationMinutes(int minutes) {
  if (minutes < 5) return 0;
  if (minutes < 10) return 10;
  if (minutes < 15) return 15;
  if (minutes < 20) return 20;
  if (minutes < 30) return 25;
  return 30;
}

/// XP earned for a completed workout based on routine duration in minutes (spec §3.1).
/// <=10min=15, <=15min=25, <=20min=30, >20min=40.
int xpForWorkoutDurationMinutes(int minutes) {
  if (minutes <= 0) return 0;
  if (minutes <= 10) return 15;
  if (minutes <= 15) return 25;
  if (minutes <= 20) return 30;
  return 40;
}
