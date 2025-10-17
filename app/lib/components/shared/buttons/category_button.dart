import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final Color activeBackgroundColor;
  final Color backgroundColor;
  final Color activeTextColor;
  final Color textColor;
  final bool? isActive;
  final String? icon;
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
      this.padding,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return RippleWrapper(
      onPressed: onPressed,
      child: Container(
          padding: padding ?? EdgeInsets.all(10),
          height: height ?? 40,
          decoration: BoxDecoration(
              color: isActive == true ? activeBackgroundColor : backgroundColor,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Container(
                      margin: EdgeInsets.only(right: 8),
                      child: SvgPicture.asset(
                        icon!,
                        colorFilter: ColorFilter.mode(
                            isActive == true ? activeTextColor : textColor,
                            BlendMode.srcIn),
                      ),
                    )
                  : SizedBox.shrink(),
              Text(title,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: isActive == true ? activeTextColor : textColor,
                      fontWeight: FontWeight.w500))
            ],
          )),
    );
  }
}
