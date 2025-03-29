import 'package:flutter/material.dart';

class ListEntry extends StatelessWidget {
  final String title;
  final String label;
  final bool? isFeatured;
  const ListEntry(
      {super.key, required this.title, required this.label, this.isFeatured});

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
              color: isFeatured == true
                  ? colors.secondary.withAlpha(150)
                  : colors.tertiaryContainer.withAlpha(150),
              fontWeight: FontWeight.w400),
        ),
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: isFeatured == true
                    ? colors.secondary
                    : colors.tertiaryContainer,
                fontWeight: FontWeight.w600))
      ],
    );
  }
}
