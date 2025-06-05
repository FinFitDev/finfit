import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class RippleWrapper extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Icon? icon;
  final EdgeInsetsGeometry? padding;
  final double? customOpacity;

  const RippleWrapper({
    super.key,
    required this.child,
    required this.onPressed,
    this.icon,
    this.padding,
    this.customOpacity,
  });

  @override
  State<RippleWrapper> createState() => _RippleWrapperState();
}

class _RippleWrapperState extends State<RippleWrapper>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;
  bool isLongPress = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Adding a curve to the scale animation
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.customOpacity ?? 0.99,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    ));

    // Opacity animation with linear interpolation
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.customOpacity ?? 0.9,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pressEndCallback() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isLongPress && mounted) {
        setState(() {
          isPressed = false;
        });
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque, // Ensures the whole area captures gestures

      onTapCancel: () {
        pressEndCallback();
      },
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
        _controller.forward(); // Animate to pressed state
      },
      onLongPressStart: (details) {
        setState(() {
          isLongPress = true;
        });
        _controller.forward(); // Animate to pressed state
      },
      onLongPressEnd: (details) {
        setState(() {
          isPressed = false;
          isLongPress = false;
        });
        _controller.reverse(); // Animate back to normal size and opacity
        triggerVibrate(FeedbackType.selection);
        widget.onPressed();
      },
      onTapUp: ((details) {
        pressEndCallback();
        triggerVibrate(FeedbackType.selection);
        widget.onPressed();
      }),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
