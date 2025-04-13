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
    return FutureBuilder(
        future: ImageHelper.getDecorationImage(image),
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  filterColor ?? Colors.transparent, BlendMode.saturation),
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: snapshot.data),
              ),
            ),
          );
        });
  }
}
