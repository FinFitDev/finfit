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

  @override
  void initState() {
    super.initState();

    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 12));

    // _gradientControllerSub =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 10));

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

    // _topAlignmentAnimationSub = TweenSequence<Alignment>([
    //   TweenSequenceItem<Alignment>(
    //       tween: Tween<Alignment>(
    //           begin: Alignment.topRight, end: Alignment.topLeft),
    //       weight: 1),
    //   TweenSequenceItem<Alignment>(
    //       tween: Tween<Alignment>(
    //           begin: Alignment.topLeft, end: Alignment.topRight),
    //       weight: 1),
    // ]).animate(_gradientControllerSub);

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

    // _bottomAlignmentAnimationSub = TweenSequence<Alignment>([
    //   TweenSequenceItem<Alignment>(
    //       tween: Tween<Alignment>(
    //           begin: Alignment.bottomLeft, end: Alignment.bottomRight),
    //       weight: 1),
    //   TweenSequenceItem<Alignment>(
    //       tween: Tween<Alignment>(
    //           begin: Alignment.bottomRight, end: Alignment.bottomLeft),
    //       weight: 1),
    // ]).animate(_gradientControllerSub);

    _gradientController.repeat();
    // _gradientControllerSub.repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    // _gradientControllerSub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // set content width for the inner application
    layoutController.setRelativeConetntWidth(MediaQuery.sizeOf(context).width);

    // set content height for the inner application taking into account the padding
    layoutController
        .setRelativeConetntHeight(MediaQuery.sizeOf(context).height);

    // set height of the bottom padding based on user platform
    layoutController.setBottomPadding(Platform.isIOS ? 25 : 0);

    return AnimatedBuilder(
        animation: _gradientController,
        builder: (context, _) {
          return Container(
              height: MediaQuery.sizeOf(context).height,
              // color: Theme.of(context).colorScheme.secondary.withAlpha(40),
              child: widget.child);
        });
  }
}
