import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleProgress extends StatelessWidget {
  final double size;
  final double progress;
  const CircleProgress({super.key, required this.size, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: CircleProgressPainter(
                progress,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.secondary.withAlpha(50)),
          ),
          progress == 1
              ? Positioned(
                  left: size / 2 - (size / 40 * 10),
                  top: size / 2 - (size / 40 * 10),
                  child: SvgPicture.asset(
                    'assets/svg/tick.svg',
                    width: (size / 40 * 20),
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.secondary,
                        BlendMode.srcIn),
                  ))
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
