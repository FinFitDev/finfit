import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:flutter/material.dart';

class ImageComponent extends StatelessWidget {
  final String? image;
  final double size;
  final Color? filterColor;
  const ImageComponent(
      {super.key, this.image, required this.size, this.filterColor});

  @override
  Widget build(BuildContext context) {
    return ImageBox(
      image: image,
      height: size,
      width: size,
      borderRadius: 100,
    );
  }
}
