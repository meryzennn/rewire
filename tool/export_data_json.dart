import 'dart:convert';
import 'dart:io';

import 'package:rewire/data/achievements_definitions.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/data/quests_definitions.dart';
import 'package:rewire/data/routines.dart';

void main() {
  final exercisesData = kAllExercises
      .map(
        (e) => {
          'id': e.id,
          'name': e.name,
          'category': e.category,
          'default_sets': e.defaultSets,
          'default_reps': e.defaultReps,
          'is_timed': e.isTimed,
          'unit': e.unit,
          'difficulty': e.difficulty,
          'description': e.description,
          'target_muscles': e.targetMuscles,
          'image_asset_path': e.imageAssetPath,
        },
      )
      .toList();

  final routinesData = kAllRoutines
      .map(
        (r) => {
          'id': r.id,
          'name': r.name,
          'subtitle': r.subtitle,
          'duration_minutes': r.durationMinutes,
          'difficulty': r.difficulty,
          'exercise_ids': r.exerciseIds,
          'description': r.description,
        },
      )
      .toList();

  final questsData = {
    'daily_pool': kDailyQuestPool
        .map(
          (q) => {
            'quest_id': q.questId,
            'type': q.type,
            'title': q.title,
            'xp_reward': q.xpReward,
            'target_value': q.targetValue,
            'description': q.description,
          },
        )
        .toList(),
    'weekly_pool': kWeeklyQuestPool
        .map(
          (q) => {
            'quest_id': q.questId,
            'type': q.type,
            'title': q.title,
            'xp_reward': q.xpReward,
            'target_value': q.targetValue,
            'description': q.description,
          },
        )
        .toList(),
  };

  final achievementsData = kAchievementDefinitions
      .map(
        (a) => {
          'badge_id': a.badgeId,
          'title': a.title,
          'icon': a.icon,
          'description': a.description,
        },
      )
      .toList();

  const encoder = JsonEncoder.withIndent('  ');

  Directory('assets/data').createSync(recursive: true);

  File('assets/data/exercises.json')
      .writeAsStringSync(encoder.convert(exercisesData));
  File('assets/data/routines.json')
      .writeAsStringSync(encoder.convert(routinesData));
  File('assets/data/quests.json')
      .writeAsStringSync(encoder.convert(questsData));
  File('assets/data/achievements.json')
      .writeAsStringSync(encoder.convert(achievementsData));

  // ignore: avoid_print
  print('Successfully exported all data JSON assets!');
}
