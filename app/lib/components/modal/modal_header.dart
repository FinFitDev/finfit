import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? goBack;
  final void Function()? onClose;
  const ModalHeader(
      {super.key,
      required this.title,
      required this.subtitle,
      this.goBack,
      this.onClose});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        onClose != null
            ? Opacity(
                opacity: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset('assets/svg/arrow_left.svg'),
                ),
              )
            : goBack != null
                ? RippleWrapper(
                    onPressed: goBack!,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset('assets/svg/arrow_left.svg'),
                    ),
                  )
                : SizedBox.shrink(),
        Column(
          children: [
            SizedBox(
              height: HORIZOTAL_PADDING,
            ),
            Text(title, style: texts.headlineLarge),
            Text(subtitle,
                style: texts.headlineMedium
                    ?.copyWith(color: colors.primaryFixedDim)),
            SizedBox(
              height: HORIZOTAL_PADDING,
            )
          ],
        ),
        goBack != null
            ? Opacity(
                opacity: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset('assets/svg/arrow_left.svg'),
                ),
              )
            : onClose != null
                ? RippleWrapper(
                    onPressed: onClose!,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        'assets/svg/close.svg',
                        colorFilter: ColorFilter.mode(
                            colors.primaryFixedDim, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
      ],
    );
  }
}
