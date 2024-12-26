import 'dart:io';

import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

class LayoutWrapper extends StatefulWidget {
  final Widget child;
  const LayoutWrapper({super.key, required this.child});

  @override
  State<LayoutWrapper> createState() => _LayoutWrapperState();
}

class _LayoutWrapperState extends State<LayoutWrapper>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  late AnimationController _gradientControllerSub;
  late Animation<Alignment> _topAlignmentAnimationSub;
  late Animation<Alignment> _bottomAlignmentAnimationSub;

  @override
  void initState() {
    super.initState();
    layoutController.setBottomPadding(Platform.isIOS ? 25 : 0);

    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 12));

    _gradientControllerSub =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_gradientController);

    _topAlignmentAnimationSub = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
    ]).animate(_gradientControllerSub);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_gradientController);

    _bottomAlignmentAnimationSub = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
    ]).animate(_gradientControllerSub);

    _gradientController.repeat();
    _gradientControllerSub.repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _gradientControllerSub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = layoutController.statusBarHeight;

    // set content height for the inner application taking into account the padding
    layoutController
        .setRelativeConetntHeight(MediaQuery.sizeOf(context).height);

    return AnimatedBuilder(
        animation: _gradientController,
        builder: (context, _) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(230, 0, 0, 0),
                Color.fromARGB(40, 107, 188, 255)
              ],
              stops: [0.37, 1],
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            )),
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(100, 0, 0, 0),
                    Color.fromARGB(40, 107, 188, 255)
                  ],
                  stops: [0.27, 1],
                  begin: _topAlignmentAnimationSub.value,
                  end: _bottomAlignmentAnimationSub.value,
                )),
                child: widget.child),
          );
        });
  }
}
