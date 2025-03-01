import 'package:flutter/material.dart';
import 'dart:math';

class TrianglePainter extends CustomPainter {
  final Color color;
  final double x;
  final double y;
  final double w;
  final double h;
  final double angle; // Rotation in degrees

  const TrianglePainter({
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

    // Define the triangle points (before rotation)
    Path path = Path();
    path.moveTo(0, -h / 2); // Top vertex
    path.lineTo(-w / 2, h / 2); // Bottom-left
    path.lineTo(w / 2, h / 2); // Bottom-right
    path.close();

    // Save the current canvas state
    canvas.save();

    // Move to the triangle's center
    canvas.translate(x + w / 2, y + h / 2);

    // Rotate the canvas
    canvas.rotate(radians);

    // Draw the rotated triangle
    canvas.drawPath(path, paint);

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.color != color ||
        oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.w != w ||
        oldDelegate.h != h;
  }
}
