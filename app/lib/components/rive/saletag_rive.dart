import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

extension TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

extension ColorExtension on Artboard {
  Shape? colorChange(String name) => component<Shape>(name);
}

class SaletagRive extends StatefulWidget {
  final int discount;
  final bool? isProgress;
  const SaletagRive({super.key, required this.discount, this.isProgress});

  @override
  State<SaletagRive> createState() => _SaletagRiveState();
}

class _SaletagRiveState extends State<SaletagRive> {
  void _onRiveInit(Artboard artboard) {
    final textRun = artboard.textRun('discount')!;
    if (widget.isProgress == true) {
      final boxComponent = artboard.colorChange('box')!;
      boxComponent.fills.first.paint.color = Colors.grey;
    }
    textRun.text = '-${widget.discount.toString()}%';
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/rive/saletag.riv',
      stateMachines: ['State Machine 1'],
      onInit: _onRiveInit,
    );
  }
}
