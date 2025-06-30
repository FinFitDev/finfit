import 'dart:math';

import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:flutter/material.dart';

class ImagesRow extends StatelessWidget {
  final List<String> images;
  final bool? isProfile;
  final double? size;
  const ImagesRow({super.key, required this.images, this.isProfile, this.size});

  @override
  Widget build(BuildContext context) {
    final gap = ((size ?? 50) / 50) * 15;
    return SizedBox(
      height: size ?? 50,
      width: (min(images.length, 3) - 1) * gap + (size ?? 50),
      child: Stack(
        children: images
            .sublist(0, min(images.length, 3))
            .asMap()
            .entries
            .map((entry) => Positioned(
                  left: entry.key * gap,
                  child: Opacity(
                    opacity: (entry.key + 1) * (1 / min(images.length, 3)),
                    child: isProfile == true
                        ? ProfileImageGenerator(
                            seed: entry.value, size: size ?? 50)
                        : ImageComponent(
                            size: size ?? 50,
                            image: entry.value,
                          ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
