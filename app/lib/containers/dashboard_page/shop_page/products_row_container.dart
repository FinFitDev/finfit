import 'package:excerbuys/components/dashboard_page/shop_page/product_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:flutter/material.dart';

class ProductsRowContainer extends StatelessWidget {
  final MapEntry<String, IProductEntry>? first;
  final MapEntry<String, IProductEntry>? second;

  const ProductsRowContainer(
      {super.key, required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: HORIZOTAL_PADDING, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: first == null
                ? UniversalLoaderBox(height: 180)
                : ProductCard(
                    originalPrice: first!.value.originalPrice,
                    discount: first!.value.discount.round(),
                    points: first!.value.finpointsPrice.round(),
                    name: first!.value.name,
                    sellerName: first!.value.owner.name,
                    sellerImage: first!.value.owner.image,
                    onPressed: () {
                      openModal(
                          context, ProductInfoModal(productId: first!.key));
                    },
                    image: first!.value.image,
                  ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: (second == null)
                ? first != null
                    ? SizedBox()
                    : UniversalLoaderBox(height: 180)
                : ProductCard(
                    originalPrice: second!.value.originalPrice,
                    discount: second!.value.discount.round(),
                    points: second!.value.finpointsPrice.round(),
                    name: second!.value.name,
                    sellerName: second!.value.owner.name,
                    sellerImage: second!.value.owner.image,
                    onPressed: () {
                      openModal(
                          context, ProductInfoModal(productId: second!.key));
                    },
                    image: second!.value.image,
                  ),
          ),
        ],
      ),
    );
  }
}
