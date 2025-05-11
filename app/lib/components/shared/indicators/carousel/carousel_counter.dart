import 'package:excerbuys/components/shared/indicators/carousel/current_item_indicator.dart';
import 'package:flutter/material.dart';

class CarouselCounter extends StatefulWidget {
  final int dataLength;
  final double scrollPercent;
  const CarouselCounter(
      {super.key, required this.dataLength, required this.scrollPercent});

  @override
  State<CarouselCounter> createState() => _CarouselCounterState();
}

class _CarouselCounterState extends State<CarouselCounter> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.dataLength, (index) {
          // 1st one -> 1 - _scrollPercent
          if (index == 0) {
            return CurrentItemIndicator(
                activePercent: 1 - widget.scrollPercent);
          }
          // others -> _scrollPercent <= index ? _scrollPercent + 1 - index : index + 1 - _scrollPercent
          return CurrentItemIndicator(
              activePercent: widget.scrollPercent <= index
                  ? widget.scrollPercent + 1 - index
                  : 1 + index - widget.scrollPercent);
        }));
  }
}
