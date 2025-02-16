import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;
  final bool? isDisabled;
  final bool? loading;

  const MainButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.isDisabled,
    this.loading,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return SizedBox(
      height: 60,
      child: TextButton(
        onPressed: widget.isDisabled != null && widget.isDisabled!
            ? null
            : widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBackgroundColor: widget.backgroundColor.withAlpha(155),
        ),
        child: widget.loading != null && widget.loading!
            ? SpinKitCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 30.0,
                controller:
                    _animationController, // Use the initialized controller
              )
            : Text(widget.label,
                style: texts.headlineLarge?.copyWith(
                  color: widget.isDisabled == true
                      ? widget.textColor.withAlpha(155)
                      : widget.textColor,
                )),
      ),
    );
  }
}
