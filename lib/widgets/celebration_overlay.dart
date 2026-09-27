import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A lightweight, cheerful celebration particle overlay.
class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({
    super.key,
    this.duration = const Duration(milliseconds: 1800),
    this.onFinished,
  });

  final Duration duration;
  final VoidCallback? onFinished;

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  final List<Color> _particleColors = const [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.warning,
    AppColors.success,
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(40, (index) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 80.0 + random.nextDouble() * 160.0;
      final size = 4.0 + random.nextDouble() * 5.0;
      final color = _particleColors[random.nextInt(_particleColors.length)];
      final rotationSpeed = (random.nextDouble() - 0.5) * 8;
      final isCircle = random.nextBool();

      return _Particle(
        angle: angle,
        speed: speed,
        size: size,
        color: color,
        rotationSpeed: rotationSpeed,
        isCircle: isCircle,
      );
    });

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward().then((_) {
        if (mounted) {
          widget.onFinished?.call();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _CelebrationPainter(
            progress: _controller.value,
            particles: _particles,
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.isCircle,
  });

  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double rotationSpeed;
  final bool isCircle;
}

class _CelebrationPainter extends CustomPainter {
  _CelebrationPainter({required this.progress, required this.particles});

  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final distance = p.speed * progress;
      final gravity = 120.0 * progress * progress;
      final x = center.dx + math.cos(p.angle) * distance;
      final y = center.dy + math.sin(p.angle) * distance + gravity;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotationSpeed * progress);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CelebrationPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
