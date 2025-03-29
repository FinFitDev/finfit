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
    final texts = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: Center(
          child: Text(
            text,
            style: texts.headlineMedium?.copyWith(
              color: isActive ? colors.secondary : colors.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
