import 'package:flutter/material.dart';

import '../../../data/exercises.dart';

/// An interactive swipeable illustration slider allowing users to slide
/// through step-by-step exercise frames manually (e.g. pushup-1 to pushup-6).
class ExerciseIllustrationSlider extends StatefulWidget {
  const ExerciseIllustrationSlider({
    super.key,
    required this.exercise,
    this.fit = BoxFit.contain,
  });

  final Exercise exercise;
  final BoxFit fit;

  @override
  State<ExerciseIllustrationSlider> createState() =>
      _ExerciseIllustrationSliderState();
}

class _ExerciseIllustrationSliderState
    extends State<ExerciseIllustrationSlider> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercise.animationFrames.isNotEmpty) {
      final frames = widget.exercise.animationFrames;
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: frames.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  frames[index],
                  fit: widget.fit,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              );
            },
          ),
          if (frames.length > 1)
            Positioned(
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    frames.length,
                    (index) => Container(
                      width: index == _currentPage ? 14 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: index == _currentPage
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Center(
      child: Image.asset(
        widget.exercise.imageAssetPath,
        fit: widget.fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
