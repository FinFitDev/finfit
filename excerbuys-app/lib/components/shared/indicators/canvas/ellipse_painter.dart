import 'package:flutter/material.dart';
import 'dart:math';

class EllipsePainter extends CustomPainter {
  final Color color;
  final double x;
  final double y;
  final double w;
  final double h;
  final double angle; // Rotation in degrees

  const EllipsePainter({
    required this.color,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Convert degrees to radians
    double radians = angle * pi / 180;

    // Define the bounding rectangle for the ellipse
    final Rect rect = Rect.fromLTWH(-w / 2, -h / 2, w, h);

    // Save the current canvas state
    canvas.save();

    // Move to the ellipse's center
    canvas.translate(x + w / 2, y + h / 2);

    // Rotate the canvas
    canvas.rotate(radians);

    // Draw the rotated ellipse
    canvas.drawOval(rect, paint);

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EllipsePainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.color != color ||
        oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.w != w ||
        oldDelegate.h != h;
  }
}
