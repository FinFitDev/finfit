import 'package:excerbuys/components/dashboard_page/shop_page/filters_button.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_card.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/shop_page/partners_container.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
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
          PartnersContainer(),
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
            child: Wrap(spacing: 8, runSpacing: 16, children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width -
                        2 * HORIZOTAL_PADDING -
                        8) /
                    2,
                child: ProductCard(
                  originalPrice: 12,
                  discount: 15,
                  points: 25000,
                  name: "Product name",
                  sellerName: 'Seller name',
                  image:
                      'https://play-lh.googleusercontent.com/Vkr8u7qdY--dP5UnKsmw63Lgl3vRpmTpw37OCH0SSu7IOZqviEvKyma2OTQuiuVTapkW',
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width -
                        2 * HORIZOTAL_PADDING -
                        8) /
                    2,
                child: ProductCard(
                  originalPrice: 12,
                  discount: 15,
                  points: 25000,
                  name: "Product name",
                  sellerName: 'Seller name',
                  image: 'https://i.ytimg.com/vi/CLPzTF6tRCc/maxresdefault.jpg',
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width -
                        2 * HORIZOTAL_PADDING -
                        8) /
                    2,
                child: ProductCard(
                  originalPrice: 12,
                  discount: 15,
                  points: 25000,
                  name: "Product name",
                  sellerName: 'Seller name',
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw7FTZRAx716uMLTlDXzbUu1XSB8yO7n3v8g&s',
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width -
                        2 * HORIZOTAL_PADDING -
                        8) /
                    2,
                child: ProductCard(
                  originalPrice: 12,
                  discount: 15,
                  points: 25000,
                  name: "Product name",
                  sellerName: 'Seller name',
                  image:
                      'https://activezone.fit/wp-content/themes/activeTheme/assets/img/hero_banner_lg.webp',
                ),
              )
            ]),
          )

          // GridView.count(
          //   padding: const EdgeInsets.only(
          //       top: 24, left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING),
          //   crossAxisCount: 2,
          //   crossAxisSpacing: 8,
          //   childAspectRatio: 4 / 5, // <<< width / height ratio

          //   mainAxisSpacing: 16,
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     ProductCard(
          //       originalPrice: 12,
          //       discount: 15,
          //       points: 25000,
          //       name: "Product name",
          //       sellerName: 'Seller name',
          //       image:
          //           'https://play-lh.googleusercontent.com/Vkr8u7qdY--dP5UnKsmw63Lgl3vRpmTpw37OCH0SSu7IOZqviEvKyma2OTQuiuVTapkW',
          //     ),
          //     ProductCard(
          //       originalPrice: 12,
          //       discount: 15,
          //       points: 25000,
          //       name: "Product name",
          //       sellerName: 'Seller name',
          //       image: 'https://i.ytimg.com/vi/CLPzTF6tRCc/maxresdefault.jpg',
          //     ),
          //     ProductCard(
          //       originalPrice: 12,
          //       discount: 15,
          //       points: 25000,
          //       name: "Product name",
          //       sellerName: 'Seller name',
          //       image:
          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw7FTZRAx716uMLTlDXzbUu1XSB8yO7n3v8g&s',
          //     ),
          //     ProductCard(
          //       originalPrice: 12,
          //       discount: 15,
          //       points: 25000,
          //       name: "Product name",
          //       sellerName: 'Seller name',
          //       image:
          //           'https://play-lh.googleusercontent.com/Vkr8u7qdY--dP5UnKsmw63Lgl3vRpmTpw37OCH0SSu7IOZqviEvKyma2OTQuiuVTapkW',
          //     )
          //     // etc.
          //   ],
          // ),

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
