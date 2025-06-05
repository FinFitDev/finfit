import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductOwnerHeaderContent extends StatelessWidget {
  const ProductOwnerHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RippleWrapper(
            child: SvgPicture.asset(
              'assets/svg/arrowBack.svg',
              width: 24,
              colorFilter:
                  ColorFilter.mode(colors.primaryFixedDim, BlendMode.srcIn),
            ),
            onPressed: () {
              productsController.handleOnClickProductOwner(null);
            }),
        StreamBuilder<String?>(
            stream: shopController.selectedProductOwnerStream,
            builder: (context, snapshot) {
              return StreamBuilder<
                      ContentWithLoading<Map<String, IProductOwnerEntry>>>(
                  stream: productOwnersController.allProductOwnersStream,
                  builder: (context, productOwnersSnapshot) {
                    return Text(
                      productOwnersSnapshot
                              .data?.content[snapshot.data ?? '']?.name ??
                          '',
                      style: texts.headlineMedium
                          ?.copyWith(color: colors.primaryFixedDim),
                    );
                  });
            }),
        SizedBox(
          width: 24,
        )
      ],
    );
  }
}
