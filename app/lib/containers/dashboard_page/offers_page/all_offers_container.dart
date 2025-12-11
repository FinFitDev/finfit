import 'package:excerbuys/components/dashboard_page/shop_page/product_card/saletag.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllOffersContainer extends StatelessWidget {
  final void Function(String) onPress;
  final Map<BigInt, IOfferEntry> offers;
  final bool isLoading;
  const AllOffersContainer(
      {super.key,
      required this.offers,
      required this.isLoading,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final offersList = offers.values.toList();

    if (offersList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Text('All rewards', style: texts.headlineLarge),
          ),
          Container(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  top: 16,
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  bottom: 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offersList.length,
              itemBuilder: (context, index) {
                final offer = offersList[index];
                final imageUrl = offer.partner.image;
                final bannerImageUrl = offer.partner.bannerImage;
                final name = offer.partner.name;
                final description = offer.description;
                final points = offer.points;
                final totalRedeemed = offer.totalRedeemed;
                final catchString = offer.catchString;
                if (isLoading) {
                  return Container(
                      margin: EdgeInsets.only(
                        top: index == 0 ? 16 : 0,
                        bottom: 16,
                      ),
                      child: UniversalLoaderBox(height: 270));
                }
                return RippleWrapper(
                  onPressed: () {
                    onPress(offer.id.toString());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 16,
                      ),
                      height: 201,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            spreadRadius: -5,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Container(
                          //   height: 100,
                          //   color: colors.primary,
                          //   child: ImageBox(
                          //     image: bannerImageUrl,
                          //     borderRadius: 0,
                          //   ),
                          // ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ImageComponent(
                                        size: 75,
                                        borderRadius: 10,
                                        image: imageUrl,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: colors.tertiary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: colors.secondary
                                                          .withAlpha(20)),
                                                  child: Text(
                                                    offer.catchString,
                                                    style: TextStyle(
                                                        color: colors.secondary,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 40,
                                              ),
                                              child: Text(
                                                description,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      colors.tertiaryContainer,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                PositionWithBackground(
                                                  name:
                                                      'Until ${parseDateYear(DateTime.parse(offer.validUntil))}',
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 5),
                                                  image:
                                                      'assets/svg/calendar.svg',
                                                  imageSize: 12,
                                                  textStyle: TextStyle(
                                                      color: colors
                                                          .primaryFixedDim,
                                                      fontSize: 10),
                                                ),
                                                PositionWithBackground(
                                                  name:
                                                      '${offer.totalRedeemed}',
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 5),
                                                  image: 'assets/svg/gift.svg',
                                                  imageSize: 12,
                                                  textStyle: TextStyle(
                                                      color: colors
                                                          .primaryFixedDim,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 0.2,
                                    color: colors.primaryFixedDim,
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  StreamBuilder<double?>(
                                      stream: userController.userBalanceStream,
                                      builder: (context, snapshot) {
                                        final bool hasEnoughPoints =
                                            (snapshot.data ?? 0) >= points;
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: 75 + 12,
                                            ),
                                            Text(
                                              points.toInt().toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: hasEnoughPoints
                                                    ? colors.secondary
                                                    : colors.tertiary
                                                        .withAlpha(50),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'pts',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: hasEnoughPoints
                                                    ? colors.primaryFixedDim
                                                    : colors.tertiary
                                                        .withAlpha(50),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 12),
                                            hasEnoughPoints
                                                ? SizedBox.shrink()
                                                : Expanded(
                                                    child:
                                                        PositionWithBackground(
                                                      name: 'Not enough',
                                                      isExpanded: true,
                                                      image:
                                                          'assets/svg/forbid.svg',
                                                      imageSize: 13,
                                                      backgroundColor: colors
                                                          .error
                                                          .withAlpha(20),
                                                      textStyle: TextStyle(
                                                          color: colors.error,
                                                          fontSize: 12),
                                                    ),
                                                  )
                                            // Container(
                                            //     padding: const EdgeInsets
                                            //         .symmetric(
                                            //         horizontal: 8,
                                            //         vertical: 2),
                                            //     decoration: BoxDecoration(
                                            //       color: colors.error
                                            //           .withAlpha(20),
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               10),
                                            //     ),
                                            //     child: Text(
                                            //       'Not enough points',
                                            //       style: TextStyle(
                                            //         fontSize: 12,
                                            //         fontWeight:
                                            //             FontWeight.w500,
                                            //         color: colors.error,
                                            //       ),
                                            //       maxLines: 1,
                                            //       overflow:
                                            //           TextOverflow.ellipsis,
                                            //     ),
                                            //   ),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
