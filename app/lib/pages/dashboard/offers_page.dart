import 'dart:async';
import 'package:excerbuys/containers/dashboard_page/home_page/featured_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/offer_info_modal.dart';
import 'package:excerbuys/containers/dashboard_page/offers_page/all_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/offers_page/offers_top_container.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/selectors/offers/offers.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/infinite_list_wrapper_v2.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  late StreamSubscription _activePageSubscription;
  late StreamSubscription _shopFiltersSubscription;
  late StreamSubscription _selectedProductOwnerSubscription;
  Timer? animationProgressTimer;

  bool _isAnimating = false;
  ScrollController scrollController = ScrollController();
  bool _shopPageInitialized = false;

  @override
  void initState() {
    super.initState();

    _activePageSubscription =
        dashboardController.activePageStream.listen((activePage) {
      if (activePage == 2 && !_shopPageInitialized) {
        _shopPageInitialized = true;
        offersController.fetchAllOffers();

        _shopFiltersSubscription = shopController.allShopFiltersStream
            .debounceTime(Duration(milliseconds: 100))
            .distinct()
            .listen((data) {});
      }
    });
  }

  @override
  void dispose() {
    _shopFiltersSubscription.cancel();
    _activePageSubscription.cancel();
    _selectedProductOwnerSubscription.cancel();
    animationProgressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<CombinedOffersData>(
        stream: offersController.combinedOffersStream,
        builder: (context, snapshot) {
          return InfiniteListWrapperV2(
            scrollController: scrollController,
            on: true,
            isLoadingMoreData: offersController.lazyLoadOffset.isLoading,
            isRefreshing: offersController.allOffers.isLoading,
            canFetchMore: offersController.canFetchMore,
            onRefresh: () {
              offersController.refresh();
            },
            onLoadMore: () {
              offersController.loadMoreData();
            },
            padding: EdgeInsets.only(
                bottom: APPBAR_HEIGHT + layoutController.bottomPadding),
            children: [
              Container(height: layoutController.statusBarHeight + 10),
              OffersTopContainer(),
              FeaturedOffersContainer(
                offers: snapshot.data?.featuredOffers.content ?? {},
                isLoading: snapshot.data?.featuredOffers.isLoading == true,
                onPress: (id) {
                  final offer = snapshot.data?.featuredOffers.content.values
                      .firstWhere((element) => element.id.toString() == id);
                  if (offer != null) {
                    openModal(
                        context,
                        OfferInfoModal(
                          offer: offer,
                        ));
                  }
                },
              ),
              AllOffersContainer(
                offers: snapshot.data?.allOffers.content ?? {},
                isLoading: snapshot.data?.allOffers.isLoading == true,
                onPress: (id) {
                  final offer = snapshot.data?.allOffers.content.values
                      .firstWhere((element) => element.id.toString() == id);
                  if (offer != null) {
                    openModal(
                        context,
                        OfferInfoModal(
                          offer: offer,
                        ));
                  }
                },
              )
            ],
          );
        });
  }
}

Widget emptyOffers(ColorScheme colors, TextTheme texts) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            'No offers found.',
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
