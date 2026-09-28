import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/l10n_utils.dart';
import '../../core/utils/provider_utils.dart';
import '../../data/meditation_definitions.dart';
import '../../providers/meditation_provider.dart';
import '../../services/audio_service.dart';
import 'meditation_complete_screen.dart';

bool get _isTestEnvironment {
  if (kIsWeb) return false;
  return Platform.environment.containsKey('FLUTTER_TEST');
}

/// Active meditation timer with visual breathing guide and ambient audio (spec §4b).
class ActiveMeditationScreen extends StatefulWidget {
  const ActiveMeditationScreen({
    super.key,
    required this.durationMinutes,
    this.trackId = 'rain',
    this.breathingId,
    this.audioService,
    this.provider,
  });

  final int durationMinutes;
  final String trackId;
  final String? breathingId;
  final AudioService? audioService;
  final MeditationProvider? provider;

  @override
  State<ActiveMeditationScreen> createState() => _ActiveMeditationScreenState();
}

class _ActiveMeditationScreenState extends State<ActiveMeditationScreen>
    with TickerProviderStateMixin {
  late final AudioService _audio;

  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCompleted = false;

  // Breathing guidance state
  BreathingPattern? _breathingPattern;
  int _currentPhaseIndex = 0;
  int _phaseSecondsRemaining = 0;
  Timer? _breathingTimer;

  late final AnimationController _circleAnimController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _audio = widget.audioService ?? AudioService.instance;
    _totalSeconds = widget.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;

    // Resolve breathing pattern
    if (widget.breathingId != null) {
      for (final p in kBreathingPatterns) {
        if (p.id == widget.breathingId) {
          _breathingPattern = p;
          break;
        }
      }
    }

    _circleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.25).animate(
      CurvedAnimation(parent: _circleAnimController, curve: Curves.easeInOut),
    );

    _initWakelock();
    _startAudio();
    _startMainTimer();
    _startBreathingCycle();
  }

  Future<void> _initWakelock() async {
    try {
      await WakelockPlus.enable();
    } catch (_) {}
  }

  Future<void> _startAudio() async {
    try {
      await _audio.play(widget.trackId);
    } catch (_) {}
  }

  void _startMainTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _onSessionComplete();
      }
    });
  }

  void _startBreathingCycle() {
    final pattern = _breathingPattern;
    if (pattern == null || pattern.phases.isEmpty) {
      if (!_isTestEnvironment) {
        _circleAnimController.repeat(reverse: true);
      } else {
        _circleAnimController.value = 0.5;
      }
      return;
    }

    _currentPhaseIndex = 0;
    _applyBreathingPhase(pattern.phases[_currentPhaseIndex]);

    _breathingTimer?.cancel();
    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_isPaused) return;

      setState(() {
        if (_phaseSecondsRemaining > 1) {
          _phaseSecondsRemaining--;
        } else {
          _currentPhaseIndex = (_currentPhaseIndex + 1) % pattern.phases.length;
          _applyBreathingPhase(pattern.phases[_currentPhaseIndex]);
        }
      });
    });
  }

  void _applyBreathingPhase(BreathingPhase phase) {
    _phaseSecondsRemaining = phase.durationSeconds;
    _circleAnimController.duration = Duration(seconds: phase.durationSeconds);

    if (phase.action == 'inhale') {
      _circleAnimController.forward();
    } else if (phase.action == 'exhale') {
      _circleAnimController.reverse();
    }
    // 'hold' maintains current scale
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
        _circleAnimController.stop();
        _audio.pause();
      } else {
        _startMainTimer();
        final pattern = _breathingPattern;
        if (pattern == null) {
          if (!_isTestEnvironment) {
            _circleAnimController.repeat(reverse: true);
          }
        }
        _audio.resume();
      }
    });
  }

  Future<void> _onSessionComplete() async {
    if (_isCompleted) return;
    _isCompleted = true;

    _timer?.cancel();
    _breathingTimer?.cancel();
    _circleAnimController.stop();
    await _audio.stop();

    try {
      await WakelockPlus.disable();
    } catch (_) {}

    if (!mounted) return;
    final provider =
        widget.provider ?? context.readOrNull<MeditationProvider>();

    if (provider != null) {
      final award = await provider.completeSession(
        durationSeconds: _totalSeconds,
        audioType: widget.trackId,
        breathingType: widget.breathingId,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => MeditationCompleteScreen(
              durationMinutes: widget.durationMinutes,
              xpAward: award,
            ),
          ),
        );
      }
    } else if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(Routes.meditation);
      }
    }
  }

  Future<void> _handleStopTap() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final langCode = getAppLanguageCode(context);

    String titleText;
    String contentText;
    String continueText;
    String endText;

    switch (langCode) {
      case 'ja':
        titleText = '瞑想セッションを終了しますか？';
        contentText = '時間が終了する前に終了したセッションでは、XPリワードを獲得できません。';
        continueText = '瞑想を続ける';
        endText = 'セッションを終了';
        break;
      case 'es':
        titleText = '¿Finalizar sesión de meditación?';
        contentText =
            'Las sesiones que finalicen antes de tiempo no recibirán recompensas de XP.';
        continueText = 'Continuar meditando';
        endText = 'Finalizar sesión';
        break;
      case 'en':
        titleText = 'End Meditation Session?';
        contentText =
            'Sessions ended before the timer completes will not earn XP rewards.';
        continueText = 'Continue Session';
        endText = 'End Session';
        break;
      default:
        titleText = 'Akhiri Sesi Meditasi?';
        contentText =
            'Sesi yang diakhiri sebelum durasi selesai tidak akan mendapatkan XP reward.';
        continueText = 'Lanjut Meditasi';
        endText = 'Akhiri Sesi';
        break;
    }

    final shouldStop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(continueText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(endText),
          ),
        ],
      ),
    );

    if (shouldStop == true && mounted) {
      _timer?.cancel();
      _breathingTimer?.cancel();
      await _audio.stop();
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(Routes.meditation);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingTimer?.cancel();
    _circleAnimController.dispose();
    _audio.stop();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  AmbientTrack? _currentTrack() {
    for (final t in kAmbientTracks) {
      if (t.id == widget.trackId) return t;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final track = _currentTrack();
    final pattern = _breathingPattern;
    final langCode = getAppLanguageCode(context);
    final l10n = AppLocalizations.of(context);

    const bgDimmed = Color(0xFF141322); // Calm, eye-friendly darkened canvas
    final lavenderAccent = AppColors.secondary;

    final trackTitle = track != null
        ? getLocalizedAmbientTrack(
            track.id,
            track.title,
            track.subtitle,
            langCode,
          ).$1
        : (l10n?.soundscapeTitle ?? 'Suasana');

    return Scaffold(
      backgroundColor: bgDimmed,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar with Minimal Sound Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          track?.emoji ?? '🎵',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          trackTitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: _handleStopTap,
                  ),
                ],
              ),

              const Spacer(),

              // Breathing Visual Guide or Pulsing Lotus Centerpiece
              AnimatedBuilder(
                animation: _circleAnimController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        lavenderAccent.withValues(alpha: 0.4),
                        lavenderAccent.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: lavenderAccent.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: lavenderAccent.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          pattern != null ? Icons.air : Icons.self_improvement,
                          size: 48,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Breathing Phase Label (if pattern active)
              if (pattern != null && pattern.phases.isNotEmpty) ...[
                Text(
                  getLocalizedBreathingPhase(
                    pattern.phases[_currentPhaseIndex].action,
                    pattern.phases[_currentPhaseIndex].label,
                    langCode,
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_phaseSecondsRemaining ${l10n?.secondsShort ?? 'detik'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                Text(
                  l10n?.focusAndBreatheNaturally ?? 'Fokus & Bernapas Alami',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],

              const SizedBox(height: 36),

              // Countdown Timer
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                '/ ${_formatTime(_totalSeconds)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Bottom Controls: Pause/Resume and Stop
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stop button
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      foregroundColor: Colors.white70,
                      minimumSize: const Size(54, 54),
                    ),
                    icon: const Icon(Icons.stop_rounded, size: 28),
                    onPressed: _handleStopTap,
                  ),
                  const SizedBox(width: 24),
                  // Pause / Play Button
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: lavenderAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(68, 68),
                      elevation: 4,
                    ),
                    icon: Icon(
                      _isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: 34,
                    ),
                    onPressed: _togglePause,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
