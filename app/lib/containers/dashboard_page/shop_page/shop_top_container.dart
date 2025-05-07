import 'package:excerbuys/components/dashboard_page/shop_page/filters_button.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/shop_page/partners_container.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopTopContainer extends StatefulWidget {
  ShopTopContainer({super.key});

  @override
  State<ShopTopContainer> createState() => _ShopTopContainerState();
}

// wee keep it alive inside the ListView builder to stop scroll jumps
class _ShopTopContainerState extends State<ShopTopContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(
          height: layoutController.statusBarHeight,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
          child: InputWithIcon(
              placeholder: 'Search shop',
              borderRadius: 10,
              verticalPadding: 12,
              rightIcon: 'assets/svg/search.svg',
              onChange: (e) {
                _debouncer.run(() {
                  shopController.setSearchValue(e);
                });
              }),
        ),
        StreamBuilder<String?>(
            stream: shopController.searchValueStream,
            builder: (context, searchSnapshot) {
              return StreamBuilder<ContentWithLoading<List<IProductEntry>>>(
                  stream: productsController.affordableHomeProductsStream,
                  builder: (context, snapshot) {
                    if (((snapshot.data == null ||
                                snapshot.data!.content.isEmpty) &&
                            snapshot.data?.isLoading != true) ||
                        searchSnapshot.data != null &&
                            searchSnapshot.data!.isNotEmpty) {
                      return SizedBox(
                        height: 32,
                      );
                    }
                    return AvailableOffers(
                      products: snapshot.data?.content ?? [],
                      isLoading: snapshot.data?.isLoading,
                    );
                  });
            }),
        StreamBuilder<ContentWithLoading<Map<String, IProductOwnerEntry>>>(
            stream: productOwnersController.searchProductOwners,
            builder: (context, snapshot) {
              if (snapshot.data?.content == null ||
                  snapshot.data!.content.isEmpty &&
                      snapshot.data?.isLoading != true) {
                return SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: PartnersContainer(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data?.isLoading == true,
                  owners: snapshot.data!.content,
                ),
              );
            }),
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
      ],
    );
  }
}
