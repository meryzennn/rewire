import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../core/utils/xp_utils.dart';
import '../../data/meditation_definitions.dart';
import '../../providers/meditation_provider.dart';

bool get _isTestEnvironment {
  if (kIsWeb) return false;
  return Platform.environment.containsKey('FLUTTER_TEST');
}

/// The Meditation home screen matching Stitch MCP screen 6cb6b51d5c4b49c39d621e21986b3948.
class MeditationHomeScreen extends StatefulWidget {
  const MeditationHomeScreen({super.key, this.provider});

  final MeditationProvider? provider;

  @override
  State<MeditationHomeScreen> createState() => _MeditationHomeScreenState();
}

class _MeditationHomeScreenState extends State<MeditationHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (!_isTestEnvironment) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final prov =
            widget.provider ?? context.readOrNull<MeditationProvider>();
        prov?.loadStats();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showCustomDurationDialog(
    BuildContext context,
    MeditationProvider? provider,
  ) {
    var minutes = provider?.selectedDurationMinutes ?? 10;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Durasi Kustom',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$minutes Menit',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: minutes.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    activeColor: AppColors.secondary,
                    onChanged: (val) {
                      setDialogState(() {
                        minutes = val.round();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    provider?.setDuration(minutes);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final provider =
        context.watchOrNull<MeditationProvider>() ?? widget.provider;

    final selectedDuration = provider?.selectedDurationMinutes ?? 10;
    final selectedTrackId = provider?.selectedTrackId ?? 'rain';
    final selectedBreathingId = provider?.selectedBreathingId;
    final totalMinutes = provider?.totalMinutes ?? 0;
    final sessionCount = provider?.sessionCount ?? 0;

    final potentialXp = xpForMeditationMinutes(selectedDuration);

    final bg = theme.scaffoldBackgroundColor;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final surfaceVariant = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final lavenderAccent = isDark
        ? AppColors.darkSecondary
        : AppColors.secondary;
    final lavenderContainer = isDark
        ? AppColors.darkSecondaryContainer
        : AppColors.secondaryContainer;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        title: Text(
          'Meditasi',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. HERO SECTION: Luminous Orb & Gentle Mindfulness Intent
              Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lavenderContainer.withValues(alpha: 0.35),
                          boxShadow: [
                            BoxShadow(
                              color: lavenderAccent.withValues(alpha: 0.25),
                              blurRadius: 28,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: surfaceColor,
                              border: Border.all(color: dividerColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.04,
                                  ),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.self_improvement,
                              size: 44,
                              color: lavenderAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Tenangkan Pikiran',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih suasana dan durasi meditasimu untuk merestorasi fokus hari ini.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (sessionCount > 0) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🧘 $totalMinutes menit · $sessionCount sesi selesai',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. DURATION SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Durasi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Waktu fokus',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ...kMeditationDurations.map((duration) {
                      final isSelected = selectedDuration == duration;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => provider?.setDuration(duration),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? lavenderAccent
                                  : surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: lavenderAccent.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.timer,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  '$duration min',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    // Custom Duration button
                    InkWell(
                      onTap: () => _showCustomDurationDialog(context, provider),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              !kMeditationDurations.contains(selectedDuration)
                              ? lavenderAccent
                              : surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune,
                              size: 14,
                              color:
                                  !kMeditationDurations.contains(
                                    selectedDuration,
                                  )
                                  ? Colors.white
                                  : textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              !kMeditationDurations.contains(selectedDuration)
                                  ? '$selectedDuration min'
                                  : 'Kustom ⏱️',
                              style: TextStyle(
                                color:
                                    !kMeditationDurations.contains(
                                      selectedDuration,
                                    )
                                    ? Colors.white
                                    : textPrimary,
                                fontWeight:
                                    !kMeditationDurations.contains(
                                      selectedDuration,
                                    )
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. AMBIENT SOUND SELECTOR: 2-Column Grid of 6 Tracks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suasana',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: lavenderContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Pilih 1 Suasana',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: lavenderAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kAmbientTracks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.45,
                ),
                itemBuilder: (context, index) {
                  final track = kAmbientTracks[index];
                  final isSelected = selectedTrackId == track.id;

                  return InkWell(
                    onTap: () => provider?.setTrack(track.id),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? lavenderContainer.withValues(
                                alpha: isDark ? 0.3 : 0.4,
                              )
                            : surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? lavenderAccent : dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.02,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          if (isSelected)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: lavenderAccent,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  track.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  track.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  track.subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: textSecondary,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 4. BREATHING EXERCISE SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latihan Pernapasan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Opsional',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // None option
                  Expanded(
                    child: InkWell(
                      onTap: () => provider?.setBreathing(null),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedBreathingId == null
                              ? lavenderContainer.withValues(
                                  alpha: isDark ? 0.3 : 0.4,
                                )
                              : surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selectedBreathingId == null
                                ? lavenderAccent
                                : dividerColor,
                            width: selectedBreathingId == null ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.air,
                              size: 20,
                              color: selectedBreathingId == null
                                  ? lavenderAccent
                                  : textSecondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Bebas',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Alami',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Box Breathing
                  Expanded(
                    child: InkWell(
                      onTap: () => provider?.setBreathing(kBoxBreathing.id),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedBreathingId == kBoxBreathing.id
                              ? lavenderContainer.withValues(
                                  alpha: isDark ? 0.3 : 0.4,
                                )
                              : surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selectedBreathingId == kBoxBreathing.id
                                ? lavenderAccent
                                : dividerColor,
                            width: selectedBreathingId == kBoxBreathing.id
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.crop_square,
                              size: 20,
                              color: selectedBreathingId == kBoxBreathing.id
                                  ? lavenderAccent
                                  : textSecondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Box',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              '4-4-4-4',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 4-7-8 Breathing
                  Expanded(
                    child: InkWell(
                      onTap: () => provider?.setBreathing(k478Breathing.id),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedBreathingId == k478Breathing.id
                              ? lavenderContainer.withValues(
                                  alpha: isDark ? 0.3 : 0.4,
                                )
                              : surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selectedBreathingId == k478Breathing.id
                                ? lavenderAccent
                                : dividerColor,
                            width: selectedBreathingId == k478Breathing.id
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bedtime,
                              size: 20,
                              color: selectedBreathingId == k478Breathing.id
                                  ? lavenderAccent
                                  : textSecondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '4-7-8',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Rileks',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 5. START BUTTON & GAMIFIED XP CALLOUT
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lavenderAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: lavenderAccent.withValues(alpha: 0.4),
                ),
                icon: const Icon(Icons.play_arrow, size: 22),
                label: const Text(
                  'Mulai Meditasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  context.push(
                    Routes.activeMeditation,
                    extra: {
                      'durationMinutes': selectedDuration,
                      'trackId': selectedTrackId,
                      'breathingId': selectedBreathingId,
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt, size: 16, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Dapatkan '),
                        TextSpan(
                          text: '+$potentialXp XP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const TextSpan(text: ' Brain Rewiring setelah selesai'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
