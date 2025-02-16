import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final Color activeBackgroundColor;
  final Color backgroundColor;
  final Color activeTextColor;
  final Color textColor;
  final bool? isActive;
  final void Function() onPressed;
  final double fontSize;
  final double? height;
  final EdgeInsets? padding;

  const CategoryButton(
      {super.key,
      required this.title,
      required this.activeBackgroundColor,
      required this.backgroundColor,
      required this.activeTextColor,
      required this.textColor,
      this.isActive,
      required this.onPressed,
      required this.fontSize,
      this.height,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: padding ?? EdgeInsets.all(10),
          height: height ?? 40,
          decoration: BoxDecoration(
              color: isActive == true ? activeBackgroundColor : backgroundColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    fontSize: fontSize,
                    color: isActive == true ? activeTextColor : textColor,
                    fontWeight: FontWeight.w500)),
          )),
    );
  }
}
