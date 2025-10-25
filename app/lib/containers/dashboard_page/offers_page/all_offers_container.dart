import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/constants.dart';
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
                      height: 328,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            spreadRadius: -5,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            color: colors.primary,
                            child: ImageBox(
                              image: bannerImageUrl,
                              borderRadius: 0,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      ImageComponent(
                                        size: 70,
                                        borderRadius: 10,
                                        image: imageUrl,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: colors.tertiary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colors.tertiaryContainer,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    catchString,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: colors.secondary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<double?>(
                                      stream: userController.userBalanceStream,
                                      builder: (context, snapshot) {
                                        final bool hasEnoughPoints =
                                            (snapshot.data ?? 0) >= points;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Cost',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colors.tertiaryContainer,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${points.toInt()} points',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: hasEnoughPoints
                                                        ? colors.tertiary
                                                        : colors.tertiary
                                                            .withAlpha(50),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(width: 16),
                                                hasEnoughPoints
                                                    ? SizedBox.shrink()
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colors.error
                                                              .withAlpha(20),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          'Not enough points',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: colors.error,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          colors.primaryFixedDim.withAlpha(20),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/svg/gift.svg',
                                            width: 12,
                                            colorFilter: ColorFilter.mode(
                                                colors.primaryFixedDim,
                                                BlendMode.srcIn)),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Redeemed $totalRedeemed times',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: colors.primaryFixedDim,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
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
