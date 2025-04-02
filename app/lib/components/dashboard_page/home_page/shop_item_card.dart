import 'dart:ui';

import 'package:excerbuys/components/rive/saletag_rive.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as Rive;

class ShopItemCard extends StatefulWidget {
  final bool? isLast;
  final String? image;
  final double originalPrice;
  final int discount;
  final int points;
  final String name;
  final String seller;
  final double? pointsLeft;

  const ShopItemCard({
    super.key,
    this.isLast,
    required this.image,
    required this.originalPrice,
    required this.discount,
    required this.points,
    required this.name,
    required this.seller,
    this.pointsLeft,
  });

  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard> {
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
            onPressed: () {},
            child: Column(
              children: [
                Stack(
                  children: [
                    ImageBox(isProgress: isProgress, image: widget.image),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                child: Container(
                                  color: colors.primary.withAlpha(170),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  height: 55,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: texts.headlineMedium
                                                  ?.copyWith(
                                                color: colors.tertiary,
                                              ),
                                            ),
                                            Text(
                                              widget.seller,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: colors.tertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
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
                        right: -10,
                        top: -20,
                        height: 120,
                        width: 120,
                        child: SaletagRive(
                          discount: widget.discount,
                          isProgress: isProgress,
                        )),
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

class ImageBox extends StatelessWidget {
  final bool isProgress;
  final String? image;
  const ImageBox({super.key, required this.isProgress, required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder(
        future: ImageHelper.getDecorationImage(image),
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  isProgress ? Colors.grey : Colors.transparent,
                  BlendMode.saturation),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(10),
                    image: snapshot.data),
              ),
            ),
          );
        });
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
