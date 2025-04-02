import 'dart:async';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/utils.dart';

class ImageHelper {
  static Future<DecorationImage> getDecorationImage(String? imageUrl,
      {String placeholderImage =
          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'}) async {
    Completer<ImageProvider> completer = Completer();
    imageUrl ??= placeholderImage;
    ImageProvider imageProvider = isNetworkImage(imageUrl)
        ? NetworkImage(imageUrl)
        : AssetImage(imageUrl) as ImageProvider;

    final ImageStream stream = imageProvider.resolve(ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (info, synchronousCall) {
          print('Success');
          if (!completer.isCompleted) {
            completer.complete(imageProvider);
          }
        },
        onError: (error, stackTrace) {
          print('Error, loading fallback image');
          ImageProvider fallbackImage = isNetworkImage(placeholderImage)
              ? NetworkImage(placeholderImage)
              : AssetImage(placeholderImage) as ImageProvider;
          if (!completer.isCompleted) {
            completer.complete(fallbackImage);
          }
        },
      ),
    );

    ImageProvider finalImage = await completer.future;
    return DecorationImage(
      image: finalImage,
      fit: BoxFit.cover,
    );
  }
}
