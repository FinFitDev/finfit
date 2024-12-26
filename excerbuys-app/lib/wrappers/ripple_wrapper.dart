import 'package:flutter/material.dart';

class RippleWrapper extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Icon? icon;
  final EdgeInsetsGeometry? padding;
  final double? customOpacity;
  const RippleWrapper(
      {super.key,
      required this.child,
      required this.onPressed,
      this.icon,
      this.padding,
      this.customOpacity});

  @override
  State<RippleWrapper> createState() => _RippleWrapperState();
}

class _RippleWrapperState extends State<RippleWrapper> {
  bool isPressed = false;
  bool isLongPress = false;

  void pressEndCallback() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isLongPress) {
        setState(() {
          isPressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () {
        pressEndCallback();
      },
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onLongPressStart: (details) {
        setState(() {
          isLongPress = true;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          isPressed = false;
          isLongPress = false;
        });
        widget.onPressed();
      },
      onTapUp: ((details) {
        pressEndCallback();
        widget.onPressed();
      }),
      child: Container(
        padding: widget.padding,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 90),
          curve: Curves.ease,
          opacity: isPressed ? (widget.customOpacity ?? 0.8) : 1,
          child: widget.child,
        ),
      ),
    );
  }
}
