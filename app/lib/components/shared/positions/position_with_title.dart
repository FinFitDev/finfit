import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PositionWithTitle extends StatelessWidget {
  final String title;
  final String? icon;
  final String value;
  const PositionWithTitle(
      {super.key, required this.title, this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors.primaryContainer),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              icon != null
                  ? SvgPicture.asset(
                      icon!,
                      colorFilter: ColorFilter.mode(
                          colors.primaryFixedDim, BlendMode.srcIn),
                      height: 20,
                    )
                  : SizedBox.shrink(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.primaryFixedDim,
                ),
              )
            ],
          ),
          Container(
            height: 0.5,
            color: colors.tertiaryContainer.withAlpha(150),
            margin: EdgeInsets.symmetric(vertical: 4),
          ),
          Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.tertiary),
          ),
        ],
      ),
    );
  }
}
