import 'package:flutter/material.dart';

class AnimatedSwitcherWrapper extends StatelessWidget {
  final Widget child;
  const AnimatedSwitcherWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.decelerate,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(animation);

        final scaleAnimation = Tween<double>(
          begin: 0.995,
          end: 1.0,
        ).animate(animation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
