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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      onTapUp: ((details) {
        widget.onPressed();
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            isPressed = false;
          });
        });
      }),
      child: Container(
        padding: widget.padding,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 90),
          curve: Curves.decelerate,
          opacity: isPressed ? (widget.customOpacity ?? 0.8) : 1,
          child: widget.child,
        ),
      ),
    );
  }
}
