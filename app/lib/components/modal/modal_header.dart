import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final void Function()? goBack;
  final void Function()? onClose;
  const ModalHeader(
      {super.key, required this.title, this.goBack, this.onClose});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      color: colors.tertiaryContainer.withAlpha(40),
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
                          ),
                          height: 30,
                          width: 30,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svg/arrow_left.svg',
                              width: 15,
                              height: 15,
                              colorFilter: ColorFilter.mode(
                                  colors.tertiary, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(title,
                    style: texts.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 20,
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
                            ),
                            height: 30,
                            width: 30,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/close.svg',
                                colorFilter: ColorFilter.mode(
                                    colors.tertiary, BlendMode.srcIn),
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
