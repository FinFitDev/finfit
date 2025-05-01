import 'dart:async';

import 'package:excerbuys/components/dashboard_page/shop_page/filters_button.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_card.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/containers/dashboard_page/shop_page/partners_container.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:payu/payu.dart';

String apiBaseUrl(Environment environment) {
  switch (environment) {
    case Environment.production:
      return 'https://secure.payu.com/';
    case Environment.sandbox:
      return 'https://secure.snd.payu.com/';
    case Environment.sandboxBeta:
      return 'https://secure.sndbeta.payu.com/';
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late StreamSubscription _activePageSubscription; // Declare the subscription
  @override
  void initState() {
    super.initState();
    _activePageSubscription =
        dashboardController.activePageStream.listen((activePage) {
      if (activePage == 1) {
        if (productsController.allProducts.content.length <= 10) {
          productsController.fetchProductsBySearch();
        }

        if (productOwnersController.allProductOwners.content.isEmpty) {
          productOwnersController.fetchProductOwners();
        }
      }
    });
  }

  @override
  void dispose() {
    _activePageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: layoutController.statusBarHeight + MAIN_HEADER_HEIGHT + 16,
          bottom: APPBAR_HEIGHT + layoutController.bottomPadding + 16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: InputWithIcon(
                placeholder: 'Search shop',
                borderRadius: 10,
                verticalPadding: 12,
                rightIcon: 'assets/svg/search.svg',
                onChange: (e) {
                  print('anything');
                }),
          ),
          StreamBuilder<ContentWithLoading<List<IProductEntry>>>(
              stream: productsController.affordableHomeProductsStream,
              builder: (context, snapshot) {
                if ((snapshot.data == null || snapshot.data!.content.isEmpty) &&
                    snapshot.data?.isLoading != true) {
                  return SizedBox.shrink();
                }
                return AvailableOffers(
                  products: snapshot.data?.content ?? [],
                  isLoading: snapshot.data?.isLoading,
                );
              }),
          StreamBuilder<ContentWithLoading<Map<String, IProductOwnerEntry>>>(
              stream: productOwnersController.searchProductOwners,
              builder: (context, snapshot) {
                if (snapshot.data?.content == null ||
                    snapshot.data!.content.isEmpty) {
                  return SizedBox.shrink();
                }

                return PartnersContainer(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data?.isLoading == true,
                  owners: snapshot.data!.content,
                );
              }),
          SizedBox(
            height: 24,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              children: [
                Expanded(
                  child: DropdownTrigger(),
                ),
                SizedBox(
                  width: 16,
                ),
                FiltersButton()
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
                left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING, top: 24),
            child:
                StreamBuilder<ContentWithLoading<Map<String, IProductEntry>>>(
                    stream: productsController.allProductsStream,
                    builder: (context, snapshot) {
                      return Wrap(
                          spacing: 8,
                          runSpacing: 16,
                          children: (snapshot.data?.content ?? {})
                              .entries
                              .map((element) {
                            final value = element.value;
                            final key = element.key;
                            final width = (MediaQuery.of(context).size.width -
                                    2 * HORIZOTAL_PADDING -
                                    8) /
                                2;

                            return SizedBox(
                              width: width,
                              child: ProductCard(
                                originalPrice: value.originalPrice,
                                discount: value.discount.round(),
                                points: value.finpointsPrice.round(),
                                name: value.name,
                                sellerName: value.owner.name,
                                sellerImage: value.owner.image,
                                onPressed: () {
                                  openModal(context,
                                      ProductInfoModal(productId: key));
                                },
                                image: value.image,
                              ),
                            );
                          }).toList());
                    }),
          )

          // RippleWrapper(
          //     child: Text('auth'),
          //     onPressed: () async {
          //       try {
          //         final res = await dio.post(
          //             '${apiBaseUrl(Environment.sandbox)}pl/standard/user/oauth/authorize',
          //             data: {
          //               "client_id": "488445",
          //               "client_secret": "0d8583a49383cb3f2c473bf19af302e5",
          //               "grant_type": "client_credentials",
          //             },
          //             options: Options(headers: {
          //               "Content-Type": "application/x-www-form-urlencoded"
          //             }));
          //         print(res);
          //       } catch (err) {
          //         print(err);
          //       }
          //     }),
        ],
      ),
    );
  }
}
