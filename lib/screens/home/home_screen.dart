import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/quest_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/level_up_dialog.dart';
import 'widgets/brain_visual.dart';
import 'widgets/daily_quests_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/streak_card.dart';

/// The central Home Screen of Rewire matching Stitch MCP screen 242853df00e24a648cb936a68b6dcc8e.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _lastLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _lastLevel = context.readOrNull<UserProvider>()?.level;
      }
    });
  }

  Future<void> _refreshAll() async {
    final now = DateTime.now();
    final userProvider = context.readOrNull<UserProvider>();
    final checkinProvider = context.readOrNull<CheckinProvider>();
    final questProvider = context.readOrNull<QuestProvider>();

    await Future.wait([
      if (userProvider != null) userProvider.loadProfile(),
      if (checkinProvider != null) checkinProvider.loadToday(now: now),
      if (questProvider != null) questProvider.loadDailyQuests(now: now),
    ]);
  }

  void _checkLevelUp(
    BuildContext context,
    int currentLevel,
    String brainStage,
  ) {
    if (_lastLevel != null && currentLevel > _lastLevel!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showLevelUpDialog(
            context,
            level: currentLevel,
            brainStage: brainStage,
          );
        }
      });
    }
    _lastLevel = currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    final userProvider = context.watchOrNull<UserProvider>();
    if (userProvider != null) {
      _checkLevelUp(context, userProvider.level, userProvider.brainStage);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Row(
          children: [
            Icon(Icons.psychology, color: primaryColor, size: 26),
            const SizedBox(width: 8),
            Text(
              'Rewire',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: _refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                // 1. Brain Visualization Card
                BrainVisual(),
                SizedBox(height: 16),

                // 2. Streak Card
                StreakCard(),
                SizedBox(height: 16),

                // 3. Daily Quests Card
                DailyQuestsCard(),
                SizedBox(height: 16),

                // 4. Quick Actions Card
                QuickActions(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
