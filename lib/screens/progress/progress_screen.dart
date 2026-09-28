import 'package:flutter/material.dart';

import '../../core/database/database_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/daily_checkin.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/quest_provider.dart';
import '../../providers/user_provider.dart';
import '../../repositories/checkin_repository.dart';
import '../../repositories/meditation_repository.dart';
import '../../repositories/workout_repository.dart';
import 'widgets/achievement_grid.dart';
import 'widgets/brain_timeline.dart';
import 'widgets/mood_trend_chart.dart';
import 'widgets/stat_cards_grid.dart';
import 'widgets/streak_chart.dart';
import 'widgets/weekly_challenges.dart';

/// The Progress dashboard screen matching Stitch MCP screen 9793a10ea659491ba0d42832bd4e99cd
/// and spec §9, Screen 6.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    this.checkinRepo,
    this.meditationRepo,
    this.workoutRepo,
    this.userProvider,
    this.questProvider,
    this.achievementProvider,
    this.initialCheckins,
    this.initialCleanDays,
    this.initialMeditationMinutes,
    this.initialWorkoutSessions,
  });

  final CheckinRepository? checkinRepo;
  final MeditationRepository? meditationRepo;
  final WorkoutRepository? workoutRepo;
  final UserProvider? userProvider;
  final QuestProvider? questProvider;
  final AchievementProvider? achievementProvider;

  final List<DailyCheckin>? initialCheckins;
  final int? initialCleanDays;
  final int? initialMeditationMinutes;
  final int? initialWorkoutSessions;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<DailyCheckin> _checkins = const [];
  int _cleanDays = 0;
  int _meditationMinutes = 0;
  int _workoutSessions = 0;

  @override
  void initState() {
    super.initState();
    _checkins = widget.initialCheckins ?? const [];
    _cleanDays = widget.initialCleanDays ?? 0;
    _meditationMinutes = widget.initialMeditationMinutes ?? 0;
    _workoutSessions = widget.initialWorkoutSessions ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    try {
      final userProv =
          widget.userProvider ?? context.readOrNull<UserProvider>();
      final questProv =
          widget.questProvider ?? context.readOrNull<QuestProvider>();
      final achProv =
          widget.achievementProvider ??
          context.readOrNull<AchievementProvider>();

      await userProv?.loadProfile();
      await questProv?.loadAllQuests();
      await achProv?.loadAchievements();

      CheckinRepository? cRepo = widget.checkinRepo;
      MeditationRepository? mRepo = widget.meditationRepo;
      WorkoutRepository? wRepo = widget.workoutRepo;

      // If repositories not directly injected, resolve from DatabaseHelper
      if (cRepo == null || mRepo == null || wRepo == null) {
        try {
          final db = await DatabaseHelper.instance.database;
          cRepo ??= CheckinRepository(db);
          mRepo ??= MeditationRepository(db);
          wRepo ??= WorkoutRepository(db);
        } catch (_) {
          // If in an environment without database, fallback gracefully
        }
      }

      if (cRepo != null) {
        _cleanDays = await cRepo.countByStatus('clean');
        _checkins = await cRepo.getHistory(limit: 30);
      }

      if (mRepo != null) {
        final sec = await mRepo.totalCompletedSeconds();
        _meditationMinutes = sec ~/ 60;
      }

      if (wRepo != null) {
        _workoutSessions = await wRepo.completedCount();
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = theme.scaffoldBackgroundColor;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final accent = isDark ? AppColors.darkAccent : AppColors.accent;

    final userProv = widget.userProvider ?? context.watchOrNull<UserProvider>();
    final questProv =
        widget.questProvider ?? context.watchOrNull<QuestProvider>();
    final achProv =
        widget.achievementProvider ??
        context.watchOrNull<AchievementProvider>();

    final profile = userProv?.profile;
    final level = profile?.level ?? 1;
    final totalXp = profile?.totalXp ?? 0;
    final currentStreak = profile?.currentStreak ?? 0;
    final longestStreak = profile?.longestStreak ?? 0;
    final brainStage = profile?.brainStage ?? 'dormant';

    final weeklyQuests = questProv?.weeklyQuests ?? const [];
    final achievements = achProv?.items ?? const [];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: accent,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Top Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.insights, color: accent, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)?.navProgress ??
                                'Progress',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Brain Evolution Hero Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: BrainTimeline(
                    level: level,
                    totalXp: totalXp,
                    brainStage: brainStage,
                  ),
                ),
              ),

              // 3. Stats Bento Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: StatCardsGrid(
                    currentStreak: currentStreak,
                    longestStreak: longestStreak,
                    cleanDays: _cleanDays,
                    meditationMinutes: _meditationMinutes,
                    workoutSessions: _workoutSessions,
                    totalXp: totalXp,
                  ),
                ),
              ),

              // 4. Streak History Chart (7 Days Bar Chart)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: StreakChart(checkins: _checkins),
                ),
              ),

              // 5. Mood Trend Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: MoodTrendChart(checkins: _checkins),
                ),
              ),

              // 6. Weekly Challenges
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: WeeklyChallenges(challenges: weeklyQuests),
                ),
              ),

              // 7. Achievements Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: AchievementGrid(achievements: achievements),
                ),
              ),

              // Bottom spacing for navigation bar
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),
    );
  }
}
