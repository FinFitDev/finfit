import 'package:flutter/material.dart';

class ListEntry extends StatelessWidget {
  final String title;
  final String label;
  const ListEntry({super.key, required this.title, required this.label});

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
              color: colors.tertiaryContainer,
              fontWeight: FontWeight.w300),
        ),
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: colors.tertiaryContainer,
                fontWeight: FontWeight.w600))
      ],
    );
  }
}
