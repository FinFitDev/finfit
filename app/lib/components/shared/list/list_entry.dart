import 'package:flutter/material.dart';

class ListEntry extends StatelessWidget {
  final String title;
  final String? label;
  final Widget? component;
  final Color? textColor;
  const ListEntry(
      {super.key,
      required this.title,
      this.label,
      this.textColor,
      this.component});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 13,
              color: textColor?.withAlpha(200) ??
                  colors.primaryFixedDim.withAlpha(200),
              fontWeight: FontWeight.w300),
        ),
        label != null
            ? Text(label!,
                style: TextStyle(
                    fontSize: 13,
                    color: textColor ?? colors.tertiaryContainer,
                    fontWeight: FontWeight.w600))
            : component ?? SizedBox.shrink()
      ],
    );
  }
}
