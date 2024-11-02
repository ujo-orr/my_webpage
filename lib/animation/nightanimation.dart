import 'dart:math';
import 'package:flutter/material.dart';

class StarryNightPainter extends CustomPainter {
  final List<Offset> starPositions; // 별의 위치를 저장할 리스트
  final double opacity;

  StarryNightPainter({required this.starPositions, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    for (var position in starPositions) {
      final radius = Random().nextDouble() * 2.0; // 각 별의 크기는 랜덤
      paint.color = Colors.white.withOpacity(opacity); // 애니메이션에 따라 투명도 설정
      canvas.drawCircle(position, radius, paint); // 고정된 위치에 별을 그림
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 매 프레임마다 repaint
  }
}
