import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ProductInfoHeader extends StatelessWidget {
  final IProductEntry? product;
  const ProductInfoHeader({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING, vertical: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            product?.name ?? '',
            style: texts.headlineLarge,
          ),
          SizedBox(
            height: 8,
          ),
          RippleWrapper(
            onPressed: () {
              closeModal(context);
            },
            child: PositionWithBackground(
                name: product?.owner.name ?? '',
                image: product?.owner.image ?? '',
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                textStyle: TextStyle(
                  fontSize: 14,
                )),
          ),
          product?.description != null && product!.description.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(product!.description,
                      style: texts.bodyMedium
                          ?.copyWith(color: colors.primaryFixedDim)),
                )
              : SizedBox.shrink(),
        ]));
  }
}
