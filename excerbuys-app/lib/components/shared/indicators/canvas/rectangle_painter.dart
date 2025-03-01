import 'package:flutter/material.dart';
import 'dart:math'; // Import for converting degrees to radians

class RectanglePainter extends CustomPainter {
  final Color color;
  final double x;
  final double y;
  final double w;
  final double h;
  final double angle; // Rotation angle in degrees

  const RectanglePainter({
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

    // Save the current canvas state
    canvas.save();

    // Move the canvas to the center of the rectangle
    canvas.translate(x + w / 2, y + h / 2);

    // Rotate the canvas
    canvas.rotate(radians);

    // Draw the rectangle centered at (0,0) (because we translated before)
    canvas.drawRect(
        Rect.fromCenter(center: Offset(0, 0), width: w, height: h), paint);

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RectanglePainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.color != color ||
        oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.w != w ||
        oldDelegate.h != h;
  }
}
