import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;
  final bool? isDisabled;
  final bool? loading;
  const MainButton(
      {super.key,
      required this.label,
      required this.backgroundColor,
      required this.textColor,
      required this.onPressed,
      this.isDisabled,
      this.loading});

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: TextButton(
          onPressed: widget.isDisabled != null && widget.isDisabled!
              ? null
              : widget.onPressed,
          style: TextButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              disabledBackgroundColor: widget.backgroundColor.withOpacity(0.5)),
          child: widget.loading != null && widget.loading!
              ? SpinKitCircle(
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 30.0,
                  controller: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1200)),
                )
              : Text(
                  widget.label,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: widget.isDisabled == true
                          ? widget.textColor.withOpacity(0.5)
                          : widget.textColor),
                )),
    );
  }
}
