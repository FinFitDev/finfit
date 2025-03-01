import 'dart:async';

import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class MainButton extends StatefulWidget {
  final String label;
  final String? icon;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;
  final bool? isDisabled;
  final bool? loading;
  final bool? holdToConfirm;

  const MainButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.isDisabled,
    this.loading,
    this.holdToConfirm,
    this.icon,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  Timer? progressTimer;
  final ValueNotifier<double> holdProgressNotifier = ValueNotifier(0.0);
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

  void _incrementProgress() {
    if (holdProgressNotifier.value >= 100) {
      widget.onPressed();
      triggerVibrate(FeedbackType.success);
      return;
    }

    double interval =
        25 - (holdProgressNotifier.value / 5); // Reduce interval over time

    progressTimer = Timer(Duration(milliseconds: interval.toInt()), () {
      setState(() {
        holdProgressNotifier.value += 1; // Increase progress
      });
      _incrementProgress(); // Recursively call again
    });
  }

  void onConfirm() {
    widget.onPressed();
    triggerVibrate(FeedbackType.success);
  }

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return SizedBox(
      height: 60,
      child: GestureDetector(
        onLongPressStart: (e) {
          if (widget.holdToConfirm != true || widget.isDisabled == true) {
            return;
          }
          _incrementProgress();
        },
        onLongPressEnd: (e) {
          if (widget.holdToConfirm != true || widget.isDisabled == true) {
            return;
          }

          progressTimer?.cancel();
          holdProgressNotifier.value = 0;
        },
        child: TextButton(
            onPressed: (widget.isDisabled != null && widget.isDisabled!)
                ? null
                : widget.holdToConfirm == true
                    ? () {}
                    : () {
                        widget.onPressed();
                        triggerVibrate(FeedbackType.selection);
                      },
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
                : ValueListenableBuilder(
                    valueListenable: holdProgressNotifier,
                    builder: (context, value, child) {
                      if (widget.holdToConfirm == true && value > 0) {
                        return CircleProgress(
                          size: 40,
                          progress: value / 100,
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.icon != null
                              ? Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: SvgPicture.asset(
                                    widget.icon!,
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                        widget.textColor, BlendMode.srcIn),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Text(widget.label,
                              style: texts.headlineMedium?.copyWith(
                                color: widget.isDisabled == true
                                    ? widget.textColor.withAlpha(155)
                                    : widget.textColor,
                              )),
                        ],
                      );
                    })),
      ),
    );
  }
}
