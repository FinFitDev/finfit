import 'dart:math';

import 'package:excerbuys/components/shared/indicators/canvas/ellipse_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/rectangle_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/triangle_painter.dart';
import 'package:flutter/material.dart';

CustomPainter getShapePainterForType(int type, Color color, double x, double y,
    double w, double h, double angle) {
  switch (type) {
    case 0:
      return RectanglePainter(
        color: color,
        x: x,
        y: y,
        w: w,
        h: w,
        angle: angle,
      );
    case 1:
      return TrianglePainter(
        color: color,
        x: x,
        y: y,
        w: w,
        h: w,
        angle: angle,
      );
    case 2:
      return EllipsePainter(
        color: color,
        x: x,
        y: y,
        w: w,
        h: w,
        angle: angle,
      );
    default:
      throw Exception('Shape type not recognized');
  }
}

String generateSeed() {
  final random = Random();

  final backgroundColor = 'FF${randomLightColor(random)}';

  List<String> shapeParts = [];

  // select shape type (square, triangle, circle)
  final type = random.nextInt(3);

  // Generate 5 shape parts
  for (int i = 0; i < 4; i++) {
    final color = 'FF${randomColor(random)}'; // Random color for shape
    final x = random.nextInt(70) - 30; // Random x coordinate between 0 and 60
    final y = random.nextInt(70) - 30; // Random y coordinate between 0 and 60
    final width = random.nextInt(21) +
        (100 - (i * 20)); // Random width between 20 and 100
    final height = random.nextInt(21) +
        (100 - (i * 20)); // Random height between 20 and 100
    final angle = random.nextInt(361); // Random angle between 0 and 360

    // Construct the shape part
    final shapePart = "${color}_${x}_${y}_${width}_${height}_$angle";

    shapeParts.add(shapePart);
  }

  // Combine the background color and shape parts to form the seed string
  return '$type|$backgroundColor|${shapeParts.join('|')}';
}

String randomColor(Random random) {
  final r = random.nextInt(150);
  final g = random.nextInt(150);
  final b = random.nextInt(150);
  return r.toRadixString(16).padLeft(2, '0') +
      g.toRadixString(16).padLeft(2, '0') +
      b.toRadixString(16).padLeft(2, '0');
}

String randomLightColor(Random random) {
  final r = random.nextInt(50) + 200;
  final g = random.nextInt(50) + 200;
  final b = random.nextInt(50) + 200;
  return r.toRadixString(16).padLeft(2, '0') +
      g.toRadixString(16).padLeft(2, '0') +
      b.toRadixString(16).padLeft(2, '0');
}
