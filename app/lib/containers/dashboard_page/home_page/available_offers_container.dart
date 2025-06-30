import 'dart:async';

import 'package:excerbuys/components/dashboard_page/shop_page/product_card/featured_product_card.dart';
import 'package:excerbuys/components/shared/indicators/carousel/carousel_counter.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/product_info_modal.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/shop/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:flutter/material.dart';

class AvailableOffers extends StatefulWidget {
  final bool? isLoading;
  final List<IProductEntry> products;
  const AvailableOffers({super.key, this.isLoading, required this.products});

  @override
  State<AvailableOffers> createState() => _AvailableOffersState();
}

class _AvailableOffersState extends State<AvailableOffers> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPercent = 0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _scrollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_scrollController.hasClients || widget.products.length <= 1) return;

      final itemWidth = layoutController.relativeContentWidth;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final nextOffset = _scrollController.offset + itemWidth;

      _scrollController.animateTo(
        nextOffset > maxScrollExtent ? 0 : nextOffset,
        duration: Duration(seconds: nextOffset > maxScrollExtent ? 3 : 1),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTimer?.cancel();
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
      margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
      child: UniversalLoaderBox(
          height: 220,
          width: MediaQuery.sizeOf(context).width - 2 * HORIZOTAL_PADDING),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2 * HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available now', style: texts.headlineLarge),
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
                        height: 220,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const PageScrollPhysics(),
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            final entry = widget.products.elementAt(index);

                            return FeaturedProductCard(
                              image: entry.mainImage,
                              originalPrice: entry.originalPrice,
                              discount: entry.discount.round(),
                              points: entry.finpointsPrice.round(),
                              name: entry.name,
                              sellerName: entry.owner.name,
                              sellerImage: entry.owner.image,
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
                            child: CarouselCounter(
                                dataLength: widget.products.length,
                                scrollPercent: _scrollPercent))
                        : SizedBox.shrink()
                  ],
                ),
        ],
      ),
    );
  }
}
