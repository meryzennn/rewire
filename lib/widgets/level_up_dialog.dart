import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'celebration_overlay.dart';

/// Shows the level-up celebration modal dialog.
Future<void> showLevelUpDialog(
  BuildContext context, {
  required int level,
  required String brainStage,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => LevelUpDialog(
      level: level,
      brainStage: brainStage,
      onDismiss: () => Navigator.of(ctx).pop(),
    ),
  );
}

/// A joyful celebration dialog presented when a user crosses a level threshold.
class LevelUpDialog extends StatelessWidget {
  const LevelUpDialog({
    super.key,
    required this.level,
    required this.brainStage,
    this.onDismiss,
  });

  final int level;
  final String brainStage;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final primaryContainer = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.primaryContainer;

    return Stack(
      children: [
        // Particle celebration overlay
        const Positioned.fill(
          child: IgnorePointer(child: CelebrationOverlay()),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glowing Trophy Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.psychology,
                      color: primaryColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'LEVEL UP!',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Level $level',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'STAGE: ${brainStage.toUpperCase()}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Jalur saraf baru berhasil terbentuk!\nOtakmu semakin bertumbuh dan berevolusi.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: onDismiss ?? () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Lanjutkan Perjalanan 🚀',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
