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
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((scale ?? 1) * 10),
            gradient: LinearGradient(colors: [
              colors.tertiary,
              colors.tertiary,
            ]),
            boxShadow: [
              BoxShadow(
                color: colors.primary,
                blurRadius: 8,
                spreadRadius: 3,
                offset: Offset(0, 0),
              ),
            ]),
        child: Center(
          child: Text(
            'Aż do $discount% taniej',
            style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12 * (scale ?? 1)),
          ),
        ),
      ),
    );
  }
}
