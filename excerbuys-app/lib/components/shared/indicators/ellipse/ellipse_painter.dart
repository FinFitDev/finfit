import 'package:flutter/material.dart';

class EllipsePainter extends CustomPainter {
  final Color color;
  const EllipsePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Define the rectangle that bounds the ellipse
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the ellipse
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return true if the painting needs to be updated
  }
}
