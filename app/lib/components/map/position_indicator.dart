import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PulsingPositionIndicator extends StatefulWidget {
  final LatLng? position;
  final Color color;
  final double size;

  const PulsingPositionIndicator({
    Key? key,
    required this.position,
    this.color = Colors.blue,
    this.size = 20,
  }) : super(key: key);

  @override
  State<PulsingPositionIndicator> createState() =>
      _PulsingPositionIndicatorState();
}

class _PulsingPositionIndicatorState extends State<PulsingPositionIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  LatLng? _previousPosition;
  bool _isPinging = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _startPulsing();
  }

  void _startPulsing() {
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.4), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.position == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color:
                  widget.color.withAlpha((100 * _pulseAnimation.value).toInt()),
            ),
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
