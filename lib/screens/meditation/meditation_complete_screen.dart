import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../services/xp_service.dart';
import '../../widgets/celebration_overlay.dart';
import '../../widgets/xp_chip.dart';

/// Screen displayed upon completing a meditation session (spec §4c).
class MeditationCompleteScreen extends StatelessWidget {
  const MeditationCompleteScreen({
    super.key,
    required this.durationMinutes,
    required this.xpAward,
  });

  final int durationMinutes;
  final XpAward xpAward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = theme.scaffoldBackgroundColor;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final lavenderAccent = isDark
        ? AppColors.darkSecondary
        : AppColors.secondary;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Gentle confetti celebration particles
          const Positioned.fill(child: CelebrationOverlay()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  // Icon badge
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lavenderAccent.withValues(alpha: 0.15),
                        border: Border.all(
                          color: lavenderAccent.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 54,
                        color: lavenderAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Headline
                  Text(
                    'Sesi Selesai! 🧘',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Duration text
                  Text(
                    '$durationMinutes menit meditasi terlewati',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // XP Awarded chip
                  Center(child: XpChip(amount: xpAward.amount, fontSize: 16)),

                  if (xpAward.leveledUp) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: AppColors.warning, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Level Up! Kamu mencapai Level ${xpAward.levelAfter}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Completion Action Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lavenderAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.meditation);
                      }
                    },
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
