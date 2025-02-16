import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarIconButton extends StatelessWidget {
  final double? padding;
  final bool? isActive;
  final String icon;
  final String name;
  final void Function() onPressed;
  final bool? isLast;
  const AppbarIconButton(
      {super.key,
      this.padding,
      this.isActive,
      required this.icon,
      required this.onPressed,
      this.isLast,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return RippleWrapper(
      onPressed: onPressed,
      child: Container(
        color: Colors.transparent,
        width: 65,
        height: 60,
        margin: EdgeInsets.only(right: isLast == true ? 0 : 20),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                  isActive == true
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiaryContainer,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive == true
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiaryContainer,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
