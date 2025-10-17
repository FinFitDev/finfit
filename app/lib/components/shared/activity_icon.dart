import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconContainer extends StatelessWidget {
  final String icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? ratio;
  final double? borderRadius;
  const IconContainer(
      {super.key,
      required this.icon,
      required this.size,
      this.backgroundColor,
      this.iconColor,
      this.ratio,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 15),
          color: backgroundColor ?? colors.secondary.withAlpha(30)),
      child: Center(
        child: SizedBox(
          width: size / 2,
          height: size / 2,
          child: SvgPicture.asset(icon,
              colorFilter: ColorFilter.mode(
                  iconColor ?? colors.secondary, BlendMode.srcIn)),
        ),
      ),
    );
  }
}
