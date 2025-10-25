import 'package:excerbuys/components/dashboard_page/shop_page/filters_button.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/dropdown_trigger.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/available_offers_container.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopTopContainer extends StatefulWidget {
  final void Function(String?) onPressPartner;
  ShopTopContainer({super.key, required this.onPressPartner});

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
    final colors = Theme.of(context).colorScheme;
    super.build(context);
    return Container(
      color: colors.primary,
      child: Column(
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
                    child: Container());
              }),
          Container(
            margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                FiltersButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
