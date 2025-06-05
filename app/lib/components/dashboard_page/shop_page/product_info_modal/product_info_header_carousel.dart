import 'dart:ui';

import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/indicators/carousel/carousel_counter.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:flutter/material.dart';

class ProductInfoHeaderCarousel extends StatefulWidget {
  final List<String> items;
  const ProductInfoHeaderCarousel({super.key, required this.items});

  @override
  State<ProductInfoHeaderCarousel> createState() =>
      _ProductInfoHeaderCarouselState();
}

class _ProductInfoHeaderCarouselState extends State<ProductInfoHeaderCarousel> {
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

  @override
  void didUpdateWidget(covariant ProductInfoHeaderCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items.any((val) => !widget.items.contains(val)) ||
        widget.items.any((val) => !oldWidget.items.contains(val))) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          color: colors.primaryContainer,
          height: 320,
          width: MediaQuery.sizeOf(context).width,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final entry = widget.items.elementAt(index);

              return ImageBox(
                image: entry,
                height: 320,
                width: layoutController.relativeContentWidth,
                borderRadius: 0,
              );
            },
          ),
        ),
        widget.items.length > 1
            ? Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          color: colors.primary.withAlpha(190),
                          child: CarouselCounter(
                              dataLength: widget.items.length,
                              scrollPercent: _scrollPercent)),
                    ),
                  ),
                ]))
            : SizedBox.shrink()
      ],
    );
  }
}
