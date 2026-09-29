import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/exercises.dart';

bool get _isTestEnvironment {
  if (kIsWeb) return false;
  return Platform.environment.containsKey('FLUTTER_TEST');
}

/// An animated slideshow illustration that fades between exercise frames
/// (e.g., pushup-1 to pushup-6) to simulate smooth exercise movement.
class AnimatedExerciseIllustration extends StatefulWidget {
  const AnimatedExerciseIllustration({
    super.key,
    required this.exercise,
    this.fit = BoxFit.contain,
    this.frameDuration = const Duration(milliseconds: 800),
    this.fadeDuration = const Duration(milliseconds: 300),
    this.autoPlay,
  });

  final Exercise exercise;
  final BoxFit fit;
  final Duration frameDuration;
  final Duration fadeDuration;
  final bool? autoPlay;

  @override
  State<AnimatedExerciseIllustration> createState() =>
      _AnimatedExerciseIllustrationState();
}

class _AnimatedExerciseIllustrationState
    extends State<AnimatedExerciseIllustration> {
  int _currentFrameIndex = 0;
  Timer? _timer;

  bool get _shouldAutoPlay => widget.autoPlay ?? !_isTestEnvironment;

  @override
  void initState() {
    super.initState();
    _startAnimationIfApplicable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.exercise.animationFrames.isNotEmpty) {
      for (final frame in widget.exercise.animationFrames) {
        precacheImage(AssetImage(frame), context);
      }
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExerciseIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _currentFrameIndex = 0;
      _timer?.cancel();
      _startAnimationIfApplicable();
    }
  }

  void _startAnimationIfApplicable() {
    if (_shouldAutoPlay && widget.exercise.animationFrames.length > 1) {
      _timer = Timer.periodic(widget.frameDuration, (_) {
        if (mounted) {
          setState(() {
            _currentFrameIndex =
                (_currentFrameIndex + 1) % widget.exercise.animationFrames.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercise.animationFrames.isNotEmpty) {
      final framePath = widget.exercise.animationFrames[_currentFrameIndex];
      return AnimatedSwitcher(
        duration: widget.fadeDuration,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Image.asset(
          framePath,
          key: ValueKey<String>(framePath),
          fit: widget.fit,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );
    }

    return Image.asset(
      widget.exercise.imageAssetPath,
      fit: widget.fit,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
