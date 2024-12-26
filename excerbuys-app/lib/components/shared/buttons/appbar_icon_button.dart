import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarIconButton extends StatelessWidget {
  final double? padding;
  final bool? isActive;
  final String icon;
  final void Function() onPressed;
  final bool? isLast;
  const AppbarIconButton(
      {super.key,
      this.padding,
      this.isActive,
      required this.icon,
      required this.onPressed,
      this.isLast});

  @override
  Widget build(BuildContext context) {
    return RippleWrapper(
      onPressed: onPressed,
      child: Container(
        color: Colors.transparent,
        width: 60,
        height: 60,
        margin: EdgeInsets.only(right: isLast == true ? 0 : 20),
        padding: EdgeInsets.all(padding ?? 18),
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
