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
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController =
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

    _gradientController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = Platform.isIOS ? 25 : 0;
    final double statusBarHeight = layoutController.statusBarHeight;

    // set content height for the inner application taking into account the padding
    layoutController.setRelativeConetntHeight(
        MediaQuery.sizeOf(context).height -
            bottomPadding -
            layoutController.statusBarHeight);

    return AnimatedBuilder(
        animation: _gradientController,
        builder: (context, _) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            padding:
                EdgeInsets.only(top: statusBarHeight, bottom: bottomPadding),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(40, 107, 188, 255)
              ],
              stops: [0.25, 1],
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            )),
            child: widget.child,
          );
        });
  }
}
