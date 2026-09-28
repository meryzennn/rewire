import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_utils.dart';
import '../../../core/utils/provider_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/user_provider.dart';

bool get _isTestEnvironment {
  if (kIsWeb) return false;
  return Platform.environment.containsKey('FLUTTER_TEST');
}

/// Brain evolution stages info.
const Map<String, String> kBrainStageDescriptions = {
  'dormant': 'Pola lama mulai diistirahatkan. Jalur saraf baru bersiap tumbuh.',
  'awakening':
      'Titik-titik kesadaran baru mulai terhubung dan menyala perlahan.',
  'growing':
      'Koneksi sinapsis baru semakin kuat, stabil, dan terbentuk teratur.',
  'thriving': 'Jaringan saraf positif berkembang pesat, fokus dan ketenangan meningkat.',
  'transcendent':
      'Jalur pemulihan terintegrasi penuh. Otakmu telah berevolusi!',
};

/// Stitch home screen brain visualization card: displays the evolving neural
/// brain, current level, brain stage, and XP progress bar with a gentle idle pulse.
class BrainVisual extends StatefulWidget {
  const BrainVisual({super.key, this.provider, this.onTap, this.enablePulse});

  final UserProvider? provider;
  final VoidCallback? onTap;
  final bool? enablePulse;

  @override
  State<BrainVisual> createState() => _BrainVisualState();
}

class _BrainVisualState extends State<BrainVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    final shouldPulse = widget.enablePulse ?? !_isTestEnvironment;
    if (shouldPulse) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showStageTimeline(BuildContext context, String currentStage) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final langCode = getAppLanguageCode(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.brainEvolutionStagesTitle ??
                        'Tahapan Evolusi Otak (Neuroplastisitas)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...kBrainStageDescriptions.entries.map((entry) {
                    final stage = entry.key;
                    final desc = getLocalizedBrainStageDescription(
                      stage,
                      entry.value,
                      langCode,
                    );
                    final isCurrent = stage == currentStage;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? (isDark
                                  ? AppColors.darkPrimaryContainer
                                  : AppColors.primaryContainer.withValues(
                                      alpha: 0.5,
                                    ))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isCurrent
                            ? Border.all(
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                              )
                            : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 18,
                            color: isCurrent
                                ? (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary)
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stage.toUpperCase(),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? (isDark
                                              ? AppColors.darkPrimary
                                              : AppColors.primary)
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  desc,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userProvider = widget.provider ?? context.watchOrNull<UserProvider>();

    final level = userProvider?.level ?? 1;
    final brainStage = userProvider?.brainStage ?? 'dormant';
    final totalXp = userProvider?.totalXp ?? 0;
    final progress = userProvider?.levelProgress ?? 0.0;
    final inLevelXp = userProvider?.xpInLevel ?? 0;
    final spanXp = userProvider?.xpSpan ?? 100;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
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
    final secondaryColor = isDark
        ? AppColors.darkSecondary
        : AppColors.secondary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap ?? () => _showStageTimeline(context, brainStage),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                // Brain Graphic with Ambient Glow and Breathing Pulse
                SizedBox(
                  width: 176,
                  height: 176,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient Subtle Glow behind brain
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryContainer.withValues(alpha: 0.4),
                        ),
                      ),
                      // Animated Breathing Brain Illustration / Fallback
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Image.asset(
                            'assets/images/brain/$brainStage.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                _StyledBrainFallback(stage: brainStage),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Level & Brain Stage Subheading
                Text(
                  l10n?.level(level) ?? 'Level $level',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  brainStage.toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 16),

                // XP Progress Bar & Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.brainRewiringProgress ?? 'Brain Rewiring Progress',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      level >= 50
                          ? (l10n?.maxLevelWithXp(totalXp) ??
                              'Max Level ($totalXp XP)')
                          : '$inLevelXp / $spanXp XP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fallback visual used when the image asset is not present or loading fails,
/// rendering an elegant glowing brain silhouette with stage styling.
class _StyledBrainFallback extends StatelessWidget {
  const _StyledBrainFallback({required this.stage});

  final String stage;

  Color get _stageColor {
    switch (stage) {
      case 'dormant':
        return Colors.grey.shade600;
      case 'awakening':
        return AppColors.primary;
      case 'growing':
        return AppColors.secondary;
      case 'thriving':
        return AppColors.accent;
      case 'transcendent':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _stageColor;

    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.35),
              color.withValues(alpha: 0.05),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.psychology, size: 76, color: color),
      ),
    );
  }
}
