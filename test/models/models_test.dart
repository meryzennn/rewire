import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/achievement.dart';
import 'package:rewire/models/daily_checkin.dart';
import 'package:rewire/models/meditation_session.dart';
import 'package:rewire/models/quest.dart';
import 'package:rewire/models/streak.dart';
import 'package:rewire/models/trigger_entry.dart';
import 'package:rewire/models/user_profile.dart';
import 'package:rewire/models/workout_session.dart';

void main() {
  test('UserProfile round-trips through map', () {
    const model = UserProfile(
      id: 1,
      level: 3,
      totalXp: 400,
      currentStreak: 5,
      longestStreak: 12,
      streakStartDate: '2026-09-01',
      brainStage: 'awakening',
      createdAt: '2026-09-01 10:00:00',
    );
    expect(UserProfile.fromMap(model.toMap()), model);
  });

  test('DailyCheckin round-trips and keeps nullable fields null', () {
    const full = DailyCheckin(
      id: 7,
      date: '2026-09-27',
      status: 'clean',
      mood: 4,
      notes: 'good day',
      xpEarned: 20,
      createdAt: '2026-09-27 08:00:00',
    );
    expect(DailyCheckin.fromMap(full.toMap()), full);

    const sparse = DailyCheckin(
      id: null,
      date: '2026-09-28',
      status: 'relapse',
      mood: null,
      notes: null,
      xpEarned: 0,
      createdAt: null,
    );
    final map = sparse.toMap();
    expect(map['mood'], isNull);
    expect(map['notes'], isNull);
    expect(DailyCheckin.fromMap(map), sparse);
  });

  test('TriggerEntry round-trips through map', () {
    const model = TriggerEntry(
      id: 2,
      date: '2026-09-27',
      description: 'stress at work',
      createdAt: '2026-09-27 09:00:00',
    );
    expect(TriggerEntry.fromMap(model.toMap()), model);
  });

  test('MeditationSession round-trips with null audio/breathing', () {
    const model = MeditationSession(
      id: 3,
      date: '2026-09-27',
      durationSeconds: 600,
      audioType: null,
      breathingType: null,
      xpEarned: 15,
      completed: 1,
      createdAt: null,
    );
    final map = model.toMap();
    expect(map['audio_type'], isNull);
    expect(map['breathing_type'], isNull);
    expect(MeditationSession.fromMap(map), model);
  });

  test('WorkoutSession round-trips through map', () {
    const model = WorkoutSession(
      id: 4,
      date: '2026-09-27',
      routineId: 'r1',
      routineName: 'Morning',
      durationSeconds: 1200,
      exercisesCompleted: 5,
      exercisesTotal: 6,
      xpEarned: 30,
      createdAt: '2026-09-27 07:00:00',
    );
    expect(WorkoutSession.fromMap(model.toMap()), model);
  });

  test('Quest round-trips with null description/date_completed', () {
    const model = Quest(
      id: 5,
      questId: 'q_daily_1',
      type: 'daily',
      title: 'Check in',
      description: null,
      xpReward: 10,
      targetValue: 1,
      currentValue: 0,
      completed: 0,
      dateAssigned: '2026-09-27',
      dateCompleted: null,
      createdAt: null,
    );
    final map = model.toMap();
    expect(map['description'], isNull);
    expect(map['date_completed'], isNull);
    expect(Quest.fromMap(map), model);
  });

  test('Achievement round-trips with null icon/date_unlocked', () {
    const model = Achievement(
      id: 6,
      badgeId: 'first_week',
      title: 'First Week',
      description: null,
      icon: null,
      unlocked: 0,
      dateUnlocked: null,
      createdAt: null,
    );
    final map = model.toMap();
    expect(map['icon'], isNull);
    expect(map['date_unlocked'], isNull);
    expect(Achievement.fromMap(map), model);
  });

  test('Streak round-trips with null end_date/ended_by', () {
    const model = Streak(
      id: 8,
      startDate: '2026-09-01',
      endDate: null,
      length: 26,
      endedBy: null,
      createdAt: null,
    );
    final map = model.toMap();
    expect(map['end_date'], isNull);
    expect(map['ended_by'], isNull);
    expect(Streak.fromMap(map), model);
  });
}
