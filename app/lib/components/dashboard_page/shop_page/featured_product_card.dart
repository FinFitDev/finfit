import 'dart:ui';

import 'package:excerbuys/components/dashboard_page/shop_page/saletag.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as Rive;

class FeaturedProductCard extends StatefulWidget {
  final bool? isLast;
  final String? image;
  final double originalPrice;
  final int discount;
  final int points;
  final String name;
  final String sellerName;
  final String? sellerImage;
  final double? pointsLeft;
  final void Function() onPressed;

  const FeaturedProductCard({
    super.key,
    this.isLast,
    required this.image,
    required this.originalPrice,
    required this.discount,
    required this.points,
    required this.name,
    required this.sellerName,
    this.sellerImage,
    this.pointsLeft,
    required this.onPressed,
  });

  @override
  State<FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<FeaturedProductCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final isProgress = widget.pointsLeft != null && widget.pointsLeft! > 0;

    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
        child: RippleWrapper(
            onPressed: widget.onPressed,
            child: Column(
              children: [
                Stack(
                  children: [
                    ImageBox(
                      border: true,
                      isProgress: isProgress,
                      image: widget.image,
                      height: 220,
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width / 1.8,
                                  color: colors.primary.withAlpha(250),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  height: 68,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: texts.headlineMedium?.copyWith(
                                          color: colors.primaryFixed,
                                        ),
                                      ),
                                      PositionWithBackground(
                                        name: widget.sellerName,
                                        image: widget.sellerImage,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // widget.progress != null
                            //     ? progressBar(widget.progress!, colors)
                            //     : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        left: 10,
                        top: 10,
                        child: Saletag(discount: widget.discount)
                        // SaletagRive(
                        //   discount: widget.discount,
                        //   isProgress: isProgress,
                        // )

                        ),
                  ],
                ),
                isProgress
                    ? StreamBuilder<bool>(
                        stream: dashboardController.balanceHiddenStream,
                        builder: (context, snapshot) {
                          final bool isHidden = snapshot.data ?? false;
                          return Container(
                            margin: const EdgeInsets.only(
                                right: HORIZOTAL_PADDING, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  isHidden
                                      ? 'Only ***** finpoints to go!'
                                      : 'Only ${formatNumber((widget.pointsLeft ?? 0).round())} finpoints to go!',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: colors.tertiaryContainer,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        })
                    : SizedBox.shrink(),
              ],
            )));
  }
}

Widget progressBar(double progress, ColorScheme colors) {
  return Container(
    height: 4,
    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colors.primary.withAlpha(70),
    ),
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: [
            Container(
              width: (progress / 100) * constraints.maxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.primary,
              ),
            ),
          ],
        );
      },
    ),
  );
}
