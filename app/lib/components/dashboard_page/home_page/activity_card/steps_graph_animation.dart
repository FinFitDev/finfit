import 'dart:async';
import 'dart:math';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StepsGraphAnimation extends StatefulWidget {
  const StepsGraphAnimation({super.key});

  @override
  State<StepsGraphAnimation> createState() => _StepsGraphAnimationState();
}

class _StepsGraphAnimationState extends State<StepsGraphAnimation> {
  List<int> _heights = List.generate(20, (_) => Random().nextInt(15));
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _heights = List.generate(20, (_) => Random().nextInt(15));
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width / 20 - 5;

    return Container(
      margin: const EdgeInsets.only(
        left: HORIZOTAL_PADDING,
        right: HORIZOTAL_PADDING,
        top: 24,
        bottom: 12,
      ),
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _heights.map((height) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: colors.secondary.withAlpha(50),
                borderRadius: BorderRadius.circular(4),
              ),
              height: height.toDouble(),
              width: width,
            );
          }).toList(),
        ),
      ),
    );
  }
}
