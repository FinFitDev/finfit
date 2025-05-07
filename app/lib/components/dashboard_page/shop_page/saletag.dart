import 'package:flutter/material.dart';

class Saletag extends StatelessWidget {
  final num discount;
  final double? scale;
  const Saletag({super.key, required this.discount, this.scale});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 80 * (scale ?? 1)),
      child: Container(
        height: 40 * (scale ?? 1),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            colors.primaryFixedDim,
            colors.tertiary,
          ]),
        ),
        child: Center(
          child: Text(
            '$discount% off',
            style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14 * (scale ?? 1)),
          ),
        ),
      ),
    );
  }
}
