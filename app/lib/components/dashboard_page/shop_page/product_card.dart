import 'package:excerbuys/components/dashboard_page/shop_page/saletag.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.primaryContainer,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ImageBox(image: widget.image),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(widget.name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      PositionWithBackground(
                        name: widget.sellerName,
                        image: widget.sellerImage,
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
                        '${widget.points.round().toString()} finpoints',
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
                child: Saletag(
                  discount: widget.discount,
                  scale: 0.8,
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
