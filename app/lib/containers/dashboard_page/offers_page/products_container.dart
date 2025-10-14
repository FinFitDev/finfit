import 'package:excerbuys/components/dashboard_page/shop_page/product_card/product_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';

class ProductsContainer extends StatefulWidget {
  const ProductsContainer({super.key});

  @override
  State<ProductsContainer> createState() => _ProductsContainerState();
}

class _ProductsContainerState extends State<ProductsContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Container();
  }
}

Widget emptyProducts(ColorScheme colors, TextTheme texts) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Text(
          'No products found.',
          style: texts.headlineMedium,
        ),
      ),
      Text(
        textAlign: TextAlign.start,
        'Modify your filters, check the internet connection and try again!',
        style: TextStyle(
          color: colors.primaryFixedDim,
        ),
      ),
    ],
  );
}
