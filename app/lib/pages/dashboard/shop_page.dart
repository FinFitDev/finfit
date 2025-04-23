import 'package:dio/dio.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/news_container.dart';
import 'package:excerbuys/containers/dashboard_page/shop_page/partners_container.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          bottom: APPBAR_HEIGHT + layoutController.bottomPadding + 260),
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
                SvgPicture.asset(
                  'assets/svg/filters.svg',
                  colorFilter:
                      ColorFilter.mode(colors.primaryFixedDim, BlendMode.srcIn),
                ),
              ],
            ),
          ),
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
