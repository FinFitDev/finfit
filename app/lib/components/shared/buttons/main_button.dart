import 'dart:async';

import 'package:excerbuys/components/shared/indicators/animations/checkmark_with_circle.dart';
import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

enum _WiggleType { none, success, error }

class MainButton extends StatefulWidget {
  final String label;
  final String? icon;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;
  final bool? isDisabled;
  final bool? loading;
  final bool? holdToConfirm;
  final double? height;
  final bool? isSuccess;
  final bool? isError; // New field

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
    this.height,
    this.isSuccess,
    this.isError, // Add to constructor
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _wiggleController;
  late final Animation<double> _successWiggle;
  late final Animation<double> _errorWiggle;
  _WiggleType _activeWiggle = _WiggleType.none;

  Timer? progressTimer;
  final ValueNotifier<double> holdProgressNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _successWiggle = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4, end: 2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 2, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.easeOut),
    );

    _errorWiggle = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.easeOut),
    );

    _wiggleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        setState(() {
          _activeWiggle = _WiggleType.none;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant MainButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess == true && oldWidget.isSuccess != true) {
      triggerVibrate(FeedbackType.success);
      _startWiggle(_WiggleType.success);
    } else if (widget.isError == true && oldWidget.isError != true) {
      triggerVibrate(FeedbackType.error);
      _startWiggle(_WiggleType.error);
    }

    if (widget.isSuccess != true && oldWidget.isSuccess == true) {
      _resetWiggle(_WiggleType.success);
    }

    if (widget.isError != true && oldWidget.isError == true) {
      _resetWiggle(_WiggleType.error);
    }
  }

  void _startWiggle(_WiggleType type) {
    setState(() {
      _activeWiggle = type;
    });
    _wiggleController.forward(from: 0);
  }

  void _resetWiggle(_WiggleType type) {
    if (_activeWiggle == type) {
      setState(() {
        _activeWiggle = _WiggleType.none;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _wiggleController.dispose();
    super.dispose();
  }

  void _incrementProgress() {
    if (holdProgressNotifier.value >= 100) {
      widget.onPressed();
      triggerVibrate(FeedbackType.success);
      return;
    }

    double interval = 25 - (holdProgressNotifier.value / 5);
    progressTimer = Timer(Duration(milliseconds: interval.toInt()), () {
      setState(() {
        holdProgressNotifier.value += 1;
      });
      _incrementProgress();
    });
  }

  void onConfirm() {
    widget.onPressed();
    triggerVibrate(FeedbackType.success);
  }

  bool get disabled {
    return widget.isDisabled == true ||
        widget.isError == true ||
        widget.isSuccess == true;
  }

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Opacity(
      opacity: widget.isDisabled == true ? 0.2 : 1,
      child: SizedBox(
        height: widget.height ?? 50,
        child: GestureDetector(
          onLongPressStart: (e) {
            if (widget.holdToConfirm != true || disabled) return;
            _incrementProgress();
          },
          onLongPressEnd: (e) {
            if (widget.holdToConfirm != true || disabled) return;
            progressTimer?.cancel();
            holdProgressNotifier.value = 0;
          },
          child: AnimatedBuilder(
            animation: _wiggleController,
            builder: (context, child) {
              Offset offset = Offset.zero;
              switch (_activeWiggle) {
                case _WiggleType.success:
                  offset = Offset(0, _successWiggle.value);
                  break;
                case _WiggleType.error:
                  offset = Offset(_errorWiggle.value, 0);
                  break;
                case _WiggleType.none:
                  offset = Offset.zero;
                  break;
              }

              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
            child: TextButton(
              onPressed: (disabled)
                  ? null
                  : widget.holdToConfirm == true
                      ? () {}
                      : () {
                          widget.onPressed();
                          triggerVibrate(FeedbackType.selection);
                        },
              style: TextButton.styleFrom(
                backgroundColor: widget.isError == true
                    ? colors.error.withAlpha(50)
                    : widget.isSuccess == true
                        ? colors.secondaryContainer.withAlpha(50)
                        : widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: widget.loading == true
                  ? SpinKitCircle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 25.0,
                      controller: _animationController,
                    )
                  : ValueListenableBuilder(
                      valueListenable: holdProgressNotifier,
                      builder: (context, value, child) {
                        if (widget.holdToConfirm == true && value > 0) {
                          return CircleProgress(
                            size: 30,
                            progress: value / 100,
                            color: Theme.of(context).colorScheme.primary,
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.isError == true
                                ? SvgPicture.asset(
                                    'assets/svg/close.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                        colors.error, BlendMode.srcIn),
                                  )
                                : widget.isSuccess == true
                                    ? SvgPicture.asset(
                                        'assets/svg/tick.svg',
                                        width: 24,
                                        height: 24,
                                        colorFilter: ColorFilter.mode(
                                            colors.secondaryContainer,
                                            BlendMode.srcIn),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          widget.icon != null
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  child: SvgPicture.asset(
                                                    widget.icon!,
                                                    width: 24,
                                                    height: 24,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            widget.textColor,
                                                            BlendMode.srcIn),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                          Text(
                                            widget.label,
                                            style:
                                                texts.headlineMedium?.copyWith(
                                              color: widget.textColor,
                                            ),
                                          ),
                                        ],
                                      )
                          ],
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }
}
