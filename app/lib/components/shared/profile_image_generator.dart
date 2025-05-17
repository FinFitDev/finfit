import 'dart:math';
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
  Color stringToColor(String input) {
    final hash = input.codeUnits.fold(0, (prev, elem) => prev + elem);
    final rnd = Random(hash);
    return HSLColor.fromAHSL(
      1.0,
      rnd.nextDouble() * 360,
      1.0,
      0.5,
    ).toColor();
  }

  List<Color> generateColors(String s) {
    final mid = s.length ~/ 2;
    final c1 = stringToColor(s.substring(0, mid));
    final c2 = stringToColor(s.substring(mid));
    return [c1, c2];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: generateColors(widget.seed ?? ""),
            ),
          ),
        ));
  }
}
