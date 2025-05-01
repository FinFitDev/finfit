import 'package:excerbuys/components/rive/saletag_rive.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String? image;
  final double originalPrice;
  final int discount;
  final int points;
  final String name;
  final String sellerName;
  final String? sellerImage;
  final void Function() onPressed;

  const ProductCard(
      {super.key,
      this.image,
      required this.originalPrice,
      required this.discount,
      required this.points,
      required this.name,
      required this.sellerName,
      this.sellerImage,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.primaryContainer,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ImageBox(image: image),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      PositionWithBackground(
                        name: sellerName,
                        image: sellerImage,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        backgroundColor: Colors.transparent,
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: colors.primaryFixedDim),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${points.round().toString()} finpoints',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.secondary),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                left: 8,
                top: 8,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      colors.primaryFixedDim,
                      colors.tertiary,
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      '$discount% off',
                      style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                )
                // SaletagRive(
                //   discount: widget.discount,
                //   isProgress: isProgress,
                // )

                ),
          ],
        ),
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  final String? image;
  const ImageBox({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder(
        future: ImageHelper.getDecorationImage(image),
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(10),
                  image: snapshot.data),
            ),
          );
        });
  }
}
