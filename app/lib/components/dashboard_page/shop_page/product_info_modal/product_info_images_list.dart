import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ProductInfoImagesList extends StatelessWidget {
  final List<String> images;
  final String? selectedImage;
  final Function(String) onImageSelected;
  const ProductInfoImagesList(
      {super.key,
      required this.images,
      this.selectedImage,
      required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 50, // Provide a fixed height
      child: ListView.builder(
        itemBuilder: (_, index) {
          return RippleWrapper(
            onPressed: () {
              onImageSelected(images[index]);
            },
            child: Container(
              margin:
                  EdgeInsets.only(right: index == images.length - 1 ? 0 : 12),
              width: 50,
              child: Opacity(
                opacity: images[index] == selectedImage ? 1 : 0.7,
                child: ImageBox(
                    image: images[index],
                    borderRadius: 8,
                    border: images[index] == selectedImage,
                    borderStyle:
                        Border.all(color: colors.errorContainer, width: 2)),
              ),
            ),
          );
        },
        itemCount: images.length,
        padding: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }
}
