import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleProgress extends StatelessWidget {
  final double size;
  final double progress;
  final Color color;
  const CircleProgress(
      {super.key,
      required this.size,
      required this.progress,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CircleProgressPainter(progress, color, color.withAlpha(50)),
    );
  }
}
