import 'dart:math';

import 'package:flutter/material.dart';

class CurrentItemIndicator extends StatelessWidget {
  final double activePercent;
  const CurrentItemIndicator({super.key, required this.activePercent});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: min(max(activePercent, 0), 1) * 15 + 6,
      height: 6,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colors.secondary
              .withAlpha((min(max(activePercent, 0), 1) * 185).round() + 60)),
    );
  }
}
