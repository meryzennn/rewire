import '../models/achievement.dart';

/// All 20 achievement badge definitions (spec §3.5). Seeded into the
/// `achievements` table via [AchievementRepository.seedAll].
///
/// `title` holds the spec's plain badge name and `icon` its emoji; `description`
/// records the unlock condition verbatim from the spec. Achievement *evaluation*
/// (thresholds vs. progress) lives in `AchievementService`, not here.
const List<Achievement> kAchievementDefinitions = [
  Achievement(
    badgeId: 'first_spark',
    title: 'First Spark',
    icon: '🔥',
    description: '1 day clean',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'week_warrior',
    title: 'One Week Warrior',
    icon: '⚡',
    description: '7-day streak',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'two_weeks',
    title: 'Fortnight Fighter',
    icon: '🌟',
    description: '14-day streak',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'lunar_cycle',
    title: 'Lunar Cycle',
    icon: '🌙',
    description: '30-day streak',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'solar_power',
    title: 'Solar Power',
    icon: '☀️',
    description: '90-day streak',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'zen_mind',
    title: 'Zen Mind',
    icon: '🧘',
    description: '100 total meditation minutes',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'deep_focus',
    title: 'Deep Focus',
    icon: '🔮',
    description: '500 total meditation minutes',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'iron_will',
    title: 'Iron Will',
    icon: '💪',
    description: '50 workouts completed',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'marathon',
    title: 'Marathon',
    icon: '🏃',
    description: '100 workouts completed',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'early_bird',
    title: 'Early Bird',
    icon: '🐦',
    description: 'Check-in before 8 AM, 7 days in a row',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'night_owl',
    title: 'Night Owl',
    icon: '🦉',
    description: 'Meditate after 10 PM, 5 times',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'consistency',
    title: 'Consistency King',
    icon: '📅',
    description: '30 consecutive daily check-ins',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'explorer',
    title: 'Explorer',
    icon: '🗺️',
    description: 'Try all 6 ambient sounds',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'full_body',
    title: 'Full Body',
    icon: '🏋️',
    description: 'Complete all workout routines at least once',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'trigger_aware',
    title: 'Trigger Aware',
    icon: '🎯',
    description: 'Log 20 triggers',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'bouncer',
    title: 'Bouncer',
    icon: '🔄',
    description: 'Resume streak within 24h of relapse',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'level_10',
    title: 'Sapling',
    icon: '🌱',
    description: 'Reach level 10',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'level_25',
    title: 'Mighty Oak',
    icon: '🌳',
    description: 'Reach level 25',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'level_50',
    title: 'Fully Rewired',
    icon: '🧠',
    description: 'Reach level 50 (max)',
    unlocked: 0,
  ),
  Achievement(
    badgeId: 'quest_master',
    title: 'Quest Master',
    icon: '⭐',
    description: 'Complete 50 daily quests total',
    unlocked: 0,
  ),
];
