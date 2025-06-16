import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? goBack;
  final void Function()? onClose;
  final String? image;
  const ModalHeader(
      {super.key,
      required this.title,
      required this.subtitle,
      this.goBack,
      this.onClose,
      this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: colors.tertiaryContainer))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            onClose != null && goBack == null
                ? Opacity(
                    opacity: 0,
                    child: Container(
                      width: 40,
                    ),
                  )
                : goBack != null
                    ? RippleWrapper(
                        onPressed: goBack!,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colors.primaryContainer),
                          height: 40,
                          width: 40,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svg/arrow_left.svg',
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
            Column(
              children: [
                SizedBox(
                  height: HORIZOTAL_PADDING,
                ),
                Row(
                  children: [
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ImageComponent(image: image, size: 20),
                          )
                        : SizedBox.shrink(),
                    Text(title,
                        style: texts.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text(subtitle,
                    style:
                        TextStyle(color: colors.primaryFixedDim, fontSize: 14)),
                SizedBox(
                  height: HORIZOTAL_PADDING,
                )
              ],
            ),
            goBack != null && onClose == null
                ? Opacity(
                    opacity: 0,
                    child: Container(
                      width: 40,
                    ),
                  )
                : onClose != null
                    ? RippleWrapper(
                        onPressed: onClose!,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: colors.primaryContainer),
                            height: 40,
                            width: 40,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/close.svg',
                                colorFilter: ColorFilter.mode(
                                    colors.primaryFixedDim, BlendMode.srcIn),
                              ),
                            )),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
