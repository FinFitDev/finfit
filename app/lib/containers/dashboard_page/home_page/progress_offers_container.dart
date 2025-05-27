import 'package:excerbuys/components/dashboard_page/shop_page/product_card/featured_product_card.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/components/shared/indicators/carousel/current_item_indicator.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';

class ProgressOffersContainer extends StatefulWidget {
  final bool? isLoading;
  final List<IProductEntry> products;
  const ProgressOffersContainer(
      {super.key, this.isLoading, required this.products});

  @override
  State<ProgressOffersContainer> createState() =>
      _ProgressOffersContainerState();
}

class _ProgressOffersContainerState extends State<ProgressOffersContainer> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPercent = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final itemWidth = layoutController.relativeContentWidth;
    final scrollOffset = _scrollController.offset;

    setState(() {
      _scrollPercent = (scrollOffset / itemWidth);
    });
  }

  Widget get loadingContainer {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
      child: UniversalLoaderBox(
          height: 220,
          width: MediaQuery.sizeOf(context).width - 2 * HORIZOTAL_PADDING),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(bottom: 2 * HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nearly there, keep going', style: texts.headlineLarge),
              ],
            ),
          ),
          widget.isLoading == true
              ? loadingContainer
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 250,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const PageScrollPhysics(),
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            final entry = widget.products.elementAt(index);

                            return FeaturedProductCard(
                              image: entry.image,
                              originalPrice: entry.originalPrice,
                              discount: entry.discount.round(),
                              points: entry.finpointsPrice.round(),
                              name: entry.name,
                              sellerName: entry.owner.name,
                              sellerImage: entry.owner.image,
                              pointsLeft: entry.finpointsPrice -
                                  (userController.userBalance ?? 0),
                              isLast: index == widget.products.length - 1,
                              onPressed: () {
                                openModal(context,
                                    ProductInfoModal(productId: entry.uuid));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    widget.products.length > 1
                        ? Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(widget.products.length,
                                    (index) {
                                  // 1st one -> 1 - _scrollPercent
                                  if (index == 0) {
                                    return CurrentItemIndicator(
                                        activePercent: 1 - _scrollPercent);
                                  }
                                  // others -> _scrollPercent <= index ? _scrollPercent + 1 - index : index + 1 - _scrollPercent
                                  return CurrentItemIndicator(
                                      activePercent: _scrollPercent <= index
                                          ? _scrollPercent + 1 - index
                                          : 1 + index - _scrollPercent);
                                })),
                          )
                        : SizedBox.shrink()
                  ],
                ),
        ],
      ),
    );
  }
}
