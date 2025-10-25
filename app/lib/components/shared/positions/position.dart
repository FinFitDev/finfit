import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class Position<T> extends StatelessWidget {
  final void Function() onPress;
  final T optionName;
  final String? icon;
  final bool? isSelected;
  const Position(
      {super.key,
      required this.onPress,
      required this.optionName,
      this.isSelected,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RippleWrapper(
      onPressed: () {
        onPress();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.primaryContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                icon != null
                    ? SvgPicture.asset(
                        icon!,
                        colorFilter: ColorFilter.mode(
                            isSelected == true
                                ? colors.secondary
                                : colors.primaryFixedDim,
                            BlendMode.srcIn),
                      )
                    : SizedBox.shrink(),
                Text(
                  optionName.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected == true
                          ? colors.secondary
                          : colors.primaryFixedDim),
                ),
              ],
            ),
            isSelected == true
                ? SvgPicture.asset(
                    'assets/svg/tick.svg',
                    colorFilter:
                        ColorFilter.mode(colors.secondary, BlendMode.srcIn),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
