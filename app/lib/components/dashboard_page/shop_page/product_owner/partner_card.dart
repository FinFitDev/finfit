import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class PartnerCard extends StatelessWidget {
  final void Function() onPressed;
  final String name;
  final String? image;
  final bool? isLoading;
  const PartnerCard(
      {super.key,
      required this.onPressed,
      required this.name,
      this.image,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RippleWrapper(
      onPressed: onPressed,
      child: Container(
        width: 90,
        padding:
            EdgeInsets.symmetric(vertical: HORIZOTAL_PADDING, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isLoading == true
                ? UniversalLoaderBox(
                    height: 70,
                    width: 70,
                    borderRadius: 100,
                  )
                : Stack(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: colors.tertiaryContainer.withAlpha(50),
                                width: 2.5)),
                      ),
                      Positioned(
                        left: 2.5,
                        top: 2.5,
                        child: ImageComponent(
                          size: 65,
                          image: image,
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 12,
            ),
            isLoading == true
                ? UniversalLoaderBox(
                    height: 16,
                  )
                : Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  )
          ],
        ),
      ),
    );
  }
}
