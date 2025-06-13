import 'package:flutter/material.dart';

class TextOverflowSlider extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration pauseDuration;

  const TextOverflowSlider({
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 3),
    this.pauseDuration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  @override
  State<TextOverflowSlider> createState() => _TextOverflowSliderState();
}

class _TextOverflowSliderState extends State<TextOverflowSlider>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late Animation<double> _animation;

  double _scrollAmount = 0;
  bool _shouldScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimation(double availableWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;
    _scrollAmount = textWidth - availableWidth + 30;

    if (_scrollAmount > 0) {
      _shouldScroll = true;

      _animation = Tween<double>(begin: 0, end: _scrollAmount).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear),
      )..addListener(() {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_animation.value);
          }
        });

      _startLoop();
    }
  }

  Future<void> _startLoop() async {
    while (mounted) {
      await _animationController.forward();
      await Future.delayed(widget.pauseDuration);
      await _animationController.reverse();
      await Future.delayed(widget.pauseDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_shouldScroll) {
          // Delay animation setup until after build to get correct width
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setupAnimation(constraints.maxWidth);
          });
        }

        return ClipRect(
          child: SizedBox(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.text,
                  style: widget.style,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
