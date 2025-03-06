import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/user/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileImageGenerator extends StatefulWidget {
  final String? seed;
  final double size;
  const ProfileImageGenerator(
      {super.key, required this.seed, required this.size});

  @override
  State<ProfileImageGenerator> createState() => _ProfileImageGeneratorState();
}

class _ProfileImageGeneratorState extends State<ProfileImageGenerator> {
  List<ShapeModel> shapesList = [];
  Color backgroundColor = Color(0xFFFFFFFF);

  void parseSeed() {
    if (widget.seed == null) {
      return;
    }

    final List<String> seedParts = widget.seed!.split('|');
    setState(() {
      backgroundColor = Color(parseInt('0x${seedParts[1]}'));

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
  void didUpdateWidget(covariant ProfileImageGenerator oldWidget) {
    super.didUpdateWidget(oldWidget);
    parseSeed();
  }

  @override
  void initState() {
    super.initState();
    parseSeed();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.seed == null
          ? Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.grey, BlendMode.saturation),
                      image: NetworkImage(
                          'https://static.vecteezy.com/system/resources/previews/036/594/092/non_2x/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg'))),
            )
          : Container(
              width: widget.size,
              height: widget.size,
              color: backgroundColor,
              child: Stack(
                children: shapesList.map((shape) {
                  return CustomPaint(
                    painter: shape.painter(
                        shape.color,
                        shape.x * (widget.size / 100),
                        shape.y * (widget.size / 100),
                        shape.w * (widget.size / 100),
                        shape.h * (widget.size / 100),
                        shape.angle),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
