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
