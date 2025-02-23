import 'dart:math';

import 'package:excerbuys/components/shared/indicators/canvas/ellipse_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/rectangle_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/triangle_painter.dart';
import 'package:excerbuys/pages/dashboard_subpages/shop_page.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:flutter/material.dart';

Future<bool> updatePointsScoreWithUpdateTimestamp(
    String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/$userId',
        body: {
          "points": points.toString(),
          "steps_updated_at": DateTime.now().toString()
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'] == 'UPDATE';
  } catch (error) {
    print(error);
    return false;
  }
}

Future<bool> updatePointsScore(String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/$userId',
        body: {
          "points": points.toString(),
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'] == 'UPDATE';
  } catch (error) {
    print(error);
    return false;
  }
}

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

  // Generate the background color (Random Color)
  final backgroundColor = 'FF' + randomLightColor(random);

  // List to hold shape parts
  List<String> shapeParts = [];

  // Generate 5 shape parts
  final type = random.nextInt(3); // Random type between 0 and 2

  for (int i = 0; i < 5; i++) {
    final color = 'FF' + randomColor(random); // Random color for shape
    final x = random.nextInt(50); // Random x coordinate between 0 and 60
    final y = random.nextInt(50); // Random y coordinate between 0 and 60
    final width =
        random.nextInt(21) + (60 - (i * 10)); // Random width between 20 and 100
    final height = random.nextInt(21) +
        (60 - (i * 10)); // Random height between 20 and 100
    final angle = random.nextInt(361); // Random angle between 0 and 360

    // Construct the shape part
    final shapePart = "${color}_${x}_${y}_${width}_${height}_$angle";

    shapeParts.add(shapePart);
  }

  // Combine the background color and shape parts to form the seed string
  return '$type-$backgroundColor-${shapeParts.join('-')}';
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
