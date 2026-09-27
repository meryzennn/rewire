import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/constants/xp_table.dart';
import 'package:rewire/core/utils/xp_utils.dart';

void main() {
  test('XP thresholds match progression checkpoints', () {
    expect(xpToReach(1), 0);
    expect(xpToReach(2), 50);
    expect(xpToReach(50), 55122);
  });

  test('levels clamp at 1 and 50, with inclusive thresholds', () {
    expect(levelForXp(-1), 1);
    expect(levelForXp(0), 1);
    expect(levelForXp(49), 1);
    expect(levelForXp(50), 2);
    expect(levelForXp(55121), 49);
    expect(levelForXp(55122), 50);
    expect(levelForXp(100000), 50);
  });

  test('precomputes one formula threshold for each level from 1 to 50', () {
    expect(xpTable, hasLength(50));
    for (var level = 1; level <= 50; level++) {
      expect(xpTable[level - 1], (50 * math.pow(level - 1, 1.8)).round());
    }
  });

  test('XP lookup clamps levels to 1 through 50', () {
    expect(xpToReach(-4), xpToReach(1));
    expect(xpToReach(51), xpToReach(50));
  });

  test('brain stages cover all specified level ranges', () {
    expect(brainStageForLevel(1), 'dormant');
    expect(brainStageForLevel(5), 'dormant');
    expect(brainStageForLevel(6), 'awakening');
    expect(brainStageForLevel(15), 'awakening');
    expect(brainStageForLevel(16), 'growing');
    expect(brainStageForLevel(25), 'growing');
    expect(brainStageForLevel(26), 'thriving');
    expect(brainStageForLevel(40), 'thriving');
    expect(brainStageForLevel(41), 'transcendent');
    expect(brainStageForLevel(50), 'transcendent');
    expect(brainStageForLevel(0), 'dormant');
    expect(brainStageForLevel(99), 'transcendent');
  });

  test('level progress calculations accurately report progress within brackets', () {
    // Level 1: 0 to 50 XP (span = 50)
    expect(xpSpanForLevel(1), 50);
    expect(xpProgressInLevel(0), 0);
    expect(levelProgressFraction(0), 0.0);

    expect(xpProgressInLevel(20), 20);
    expect(levelProgressFraction(20), 0.4);

    // Level 2: 50 to 174 XP (span = 124)
    expect(xpSpanForLevel(2), 124);
    expect(xpProgressInLevel(50), 0);
    expect(levelProgressFraction(50), 0.0);

    // Level 50 (max): progress is 1.0
    expect(levelProgressFraction(55122), 1.0);
  });

  test('meditation XP mapping matches spec §3.1', () {
    expect(xpForMeditationMinutes(0), 0);
    expect(xpForMeditationMinutes(3), 0);
    expect(xpForMeditationMinutes(5), 10);
    expect(xpForMeditationMinutes(9), 10);
    expect(xpForMeditationMinutes(10), 15);
    expect(xpForMeditationMinutes(14), 15);
    expect(xpForMeditationMinutes(15), 20);
    expect(xpForMeditationMinutes(19), 20);
    expect(xpForMeditationMinutes(20), 25);
    expect(xpForMeditationMinutes(29), 25);
    expect(xpForMeditationMinutes(30), 30);
    expect(xpForMeditationMinutes(60), 30);
  });
}
