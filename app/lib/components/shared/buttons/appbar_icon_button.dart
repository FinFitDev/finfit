import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
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
  final bool? isProfile;
  final bool? trackingPlayed;
  const AppbarIconButton(
      {super.key,
      this.padding,
      this.isActive,
      required this.icon,
      required this.onPressed,
      this.isLast,
      required this.name,
      this.isProfile,
      this.trackingPlayed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RippleWrapper(
      onPressed: onPressed,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            width: 50,
            height: 50,
            child: Column(
              children: [
                isProfile == true
                    ? ProfileImageGenerator(
                        seed: userController.currentUser?.image, size: 26)
                    : SvgPicture.asset(
                        icon,
                        colorFilter: ColorFilter.mode(
                            isActive == true
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                            BlendMode.srcIn),
                        width: 26,
                        height: 26,
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
                      fontSize: 10),
                )
              ],
            ),
          ),
          trackingPlayed != null
              ? Positioned(
                  right: 4,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: SvgPicture.asset(
                        trackingPlayed == false
                            ? 'assets/svg/play.svg'
                            : 'assets/svg/pause.svg',
                        width: 8,
                        colorFilter:
                            ColorFilter.mode(colors.primary, BlendMode.srcIn),
                      ),
                    ),
                  ))
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
