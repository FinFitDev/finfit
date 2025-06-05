import 'package:excerbuys/components/dashboard_page/shop_page/product_card/product_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
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
    return StreamBuilder<IAllProductsData>(
        stream: productsController.productsForSearchStream,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: productsController.loadingForSearchStream,
              builder: (context, loadingForSearchSnapshot) {
                final isLoading = snapshot.data?.isLoading == true ||
                    loadingForSearchSnapshot.data == true;
                final List<dynamic> data = isLoading
                    ? List.generate(10, (index) => null)
                    : (snapshot.data?.content ?? {}).entries.toList();
                if (data.isEmpty && !isLoading) {
                  return emptyProducts(colors, texts);
                }

                return Column(
                  spacing: 8,
                  children: [
                    for (int i = 0; i < data.length; i += 2)
                      Builder(builder: (context) {
                        final entry = data[i];
                        final nextEntry =
                            i + 1 < data.length ? data[i + 1] : null;

                        final current = entry;
                        final next = nextEntry;

                        return Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: current == null
                                  ? UniversalLoaderBox(height: 180)
                                  : SizedBox(
                                      child: ProductCard(
                                        originalPrice:
                                            current.value.originalPrice,
                                        discount:
                                            current.value.discount.round(),
                                        points: current.value.finpointsPrice
                                            .round(),
                                        name: current.value.name,
                                        sellerName: current.value.owner.name,
                                        sellerImage: current.value.owner.image,
                                        onPressed: () {
                                          openModal(
                                              context,
                                              ProductInfoModal(
                                                  productId: current.key));
                                        },
                                        image: current.value.image,
                                      ),
                                    ),
                            ),
                            if (next != null)
                              Expanded(
                                child: next == null
                                    ? UniversalLoaderBox(height: 180)
                                    : SizedBox(
                                        child: ProductCard(
                                          originalPrice:
                                              next.value.originalPrice,
                                          discount: next.value.discount.round(),
                                          points:
                                              next.value.finpointsPrice.round(),
                                          name: next.value.name,
                                          sellerName: next.value.owner.name,
                                          sellerImage: next.value.owner.image,
                                          onPressed: () {
                                            openModal(
                                                context,
                                                ProductInfoModal(
                                                    productId: next.key));
                                          },
                                          image: next.value.image,
                                        ),
                                      ),
                              )
                            else
                              Expanded(child: SizedBox()),
                          ],
                        );
                      }),
                  ],
                );
              });
        });
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
