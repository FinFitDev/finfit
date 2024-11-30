import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isActive;
  final String text;
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.isActive,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: isActive ? colors.secondary : colors.tertiary,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
