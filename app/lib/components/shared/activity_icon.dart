import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconContainer extends StatelessWidget {
  final String icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? ratio;
  const IconContainer(
      {super.key,
      required this.icon,
      required this.size,
      this.backgroundColor,
      this.iconColor,
      this.ratio});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: backgroundColor ?? colors.secondary),
      child: Center(
        child: SizedBox(
          width: size * (ratio ?? 0.5),
          height: size * (ratio ?? 0.5),
          child: SvgPicture.asset(icon,
              colorFilter: ColorFilter.mode(
                  iconColor ?? colors.primary, BlendMode.srcIn)),
        ),
      ),
    );
  }
}
