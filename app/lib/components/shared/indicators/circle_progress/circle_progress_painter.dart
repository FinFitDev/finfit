import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color colorFilled;
  final Color colorAmbient;

  CircleProgressPainter(this.progress, this.colorFilled, this.colorAmbient);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = colorAmbient
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 8;

    final Paint progressPaint = Paint()
      ..color = colorFilled
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 8
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Draw the background track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw the progress arc
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
