import 'dart:math';

import 'package:flutter/material.dart';

class UniversalLoaderBox extends StatefulWidget {
  final double height;
  final double width;
  final double? borderRadius;
  const UniversalLoaderBox(
      {super.key,
      required this.height,
      required this.width,
      this.borderRadius});

  @override
  State<UniversalLoaderBox> createState() => _UniversalLoaderBoxState();
}

class _UniversalLoaderBoxState extends State<UniversalLoaderBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _stopsAnimation;

  @override
  void initState() {
    super.initState();
    Random random = Random();

    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: random.nextInt(1) + 2));

    _stopsAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 0.5), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 0), weight: 1),
    ]).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Opacity(
            opacity: _stopsAnimation.value + 0.3,
            child: Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 10),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withAlpha(20),
                        Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withAlpha(100),
                      ],
                      stops: [_stopsAnimation.value, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ))),
          );
        });
  }
}
