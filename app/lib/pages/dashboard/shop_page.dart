import 'dart:async';
import 'package:excerbuys/containers/dashboard_page/shop_page/products_row_container.dart';
import 'package:excerbuys/containers/dashboard_page/shop_page/shop_top_container.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/wrappers/infinite_list_wrapper_v2.dart';
import 'package:flutter/material.dart';
import 'package:payu/payu.dart';
import 'package:rxdart/rxdart.dart';

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
  late StreamSubscription _activePageSubscription;
  late StreamSubscription _shopFiltersSubscription;

  @override
  void initState() {
    super.initState();
    if (shopController.availableCategories.isEmpty) {
      shopController.fetchAvailableCategories();
    }
    _activePageSubscription =
        dashboardController.activePageStream.listen((activePage) {
      if (activePage == 1) {
        _shopFiltersSubscription = shopController.allShopFiltersStream
            .debounceTime(Duration(milliseconds: 100))
            .distinct()
            .listen((data) {
          productsController.handleOnChangeFilters(data);
        });

        if (productOwnersController.allProductOwners.content.isEmpty) {
          productOwnersController.fetchProductOwners('');
        }
      }
    });
  }

  @override
  void dispose() {
    _shopFiltersSubscription.cancel();
    _activePageSubscription.cancel();
    super.dispose();
  }

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

            return StreamBuilder<ShopFilters?>(
              stream: shopController.shopPageUpdateTrigger(),
              builder: (context, filtersSnapshot) {
                return InfiniteListWrapperV2(
                  on: true,
                  isLoadingMoreData:
                      productsController.lazyLoadOffset.isLoading,
                  isRefreshing: productsController.allProducts.isLoading ||
                      productsController.loadingForSearch ||
                      productOwnersController.allProductOwners.isLoading,
                  canFetchMore: productsController.canFetchMore,
                  onRefresh: () {
                    productsController.refresh();
                    productOwnersController.refresh();
                  },
                  onLoadMore: () {
                    productsController
                        .fetchProductsWithFilters(filtersSnapshot.data);
                  },
                  padding: EdgeInsets.only(
                      bottom: APPBAR_HEIGHT + layoutController.bottomPadding),
                  children: [
                    ShopTopContainer(),
                    SizedBox(
                      height: 16,
                    ),
                    if (data.isEmpty)
                      emptyProducts(colors, texts)
                    else
                      // generated rows in pairs:
                      for (int i = 0; i < data.length; i += 2)
                        Builder(builder: (context) {
                          final entry = data[i];
                          final nextEntry =
                              i + 1 < data.length ? data[i + 1] : null;

                          final MapEntry<String, IProductEntry>? current =
                              entry;
                          final MapEntry<String, IProductEntry>? next =
                              nextEntry;

                          return ProductsRowContainer(
                              first: current, second: next);
                        }),
                    SizedBox(height: 32),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

Widget emptyProducts(ColorScheme colors, TextTheme texts) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
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
    ),
  );
}


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