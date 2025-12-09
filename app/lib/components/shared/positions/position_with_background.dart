import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PositionWithBackground extends StatelessWidget {
  final String name;
  final String? image;
  final double? imageSize;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  const PositionWithBackground(
      {super.key,
      required this.name,
      this.image,
      this.imageSize,
      this.textStyle,
      this.padding,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: backgroundColor ?? colors.tertiary.withAlpha(10),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          image?.contains('http') == true || image?.contains('https') == true
              ? ImageComponent(
                  size: imageSize ?? 14,
                  image: image,
                )
              : image?.contains('assets/svg') == true
                  ? SvgPicture.asset(
                      image!,
                      width: imageSize,
                      colorFilter: ColorFilter.mode(
                          textStyle?.color ?? colors.tertiary, BlendMode.srcIn),
                    )
                  : ProfileImageGenerator(
                      seed: image,
                      size: imageSize ?? 14,
                      username: name,
                    ),
          SizedBox(
            width: 6,
          ),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: colors.tertiary,
                ),
          ),
        ],
      ),
    );
  }
}
