import 'package:excerbuys/components/shared/indicators/canvas/ellipse_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/rectangle_painter.dart';
import 'package:excerbuys/components/shared/indicators/canvas/triangle_painter.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/user/profile_image.dart';
import 'package:excerbuys/utils/user/requests.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final String seed = generateSeed();
  List<ShapeModel> shapesList = [];
  // default is white
  Color backgroundColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    print(seed);
    final List<String> seedParts = seed.split('-');

    setState(() {
      backgroundColor = Color(parseInt(
          '0x${seedParts[1].substring(0, 2)}FF${seedParts[1].substring(2)}'));

      shapesList = seedParts.sublist(2).map((shape) {
        final List<String> shapeProps = shape.split("_");
        return ShapeModel(
            color: Color(parseInt(
                '0x${shapeProps[0].substring(0, 2)}FF${shapeProps[0].substring(2)}')),
            x: double.parse(shapeProps[1]),
            y: double.parse(shapeProps[2]),
            w: double.parse(shapeProps[3]),
            h: double.parse(shapeProps[4]),
            angle: double.parse(shapeProps[5]),
            painter: (color, x, y, w, h, angle) => getShapePainterForType(
                parseInt(seedParts[0]), color, x, y, w, h, angle));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 200,
            height: 200,
            color: backgroundColor,
            child: Stack(
              children: shapesList.map((shape) {
                return CustomPaint(
                  painter: shape.painter(shape.color, shape.x * 2, shape.y * 2,
                      shape.w * 2, shape.h * 2, shape.angle),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
