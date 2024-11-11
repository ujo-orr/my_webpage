import 'dart:math';
import 'package:flutter/material.dart';

class NightAnimation extends StatefulWidget {
  const NightAnimation({super.key});

  @override
  State<NightAnimation> createState() => _NightAnimationState();
}

class _NightAnimationState extends State<NightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<Offset> starPositions = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true); // 반복 애니메이션

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStars(context.size!); // 화면 크기 정보로 별 위치 초기화
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 별의 위치 초기화
  void _initializeStars(Size size) {
    if (starPositions.isEmpty) {
      final random = Random();
      for (int i = 0; i < 400; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        starPositions.add(Offset(x, y));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarryNightPainter(
            starPositions: starPositions,
            opacity: _animation.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

// 내부 Painter 클래스 - 별 그리기 기능
class _StarryNightPainter extends CustomPainter {
  final List<Offset> starPositions;
  final double opacity;

  _StarryNightPainter({required this.starPositions, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    for (var position in starPositions) {
      final radius = Random().nextDouble() * 2.0;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
