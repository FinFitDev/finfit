import 'package:flutter/material.dart';
import 'package:animated_checkmark/animated_checkmark.dart';

class CheckmarkWithCircle extends StatefulWidget {
  const CheckmarkWithCircle({Key? key}) : super(key: key);

  @override
  State<CheckmarkWithCircle> createState() => _CheckmarkWithCircleState();
}

class _CheckmarkWithCircleState extends State<CheckmarkWithCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Trigger the animation once when widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 28.0;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          return CustomPaint(
            painter: CirclePainter(_progress.value,
                color: Colors.white, strokeWidth: 2),
            child: Center(
              child: RawCheckmark(
                progress: _progress.value,
                weight: 2,
                size: 12,
                color: Colors.white,
                rounded: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CirclePainter(this.progress, {required this.color, this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Rect rect = Offset.zero & size;
    final double sweep = 2 * 3.1415926 * progress;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2), // avoid clipping at the edges
      -3.1415926 / 2, // start from top
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
