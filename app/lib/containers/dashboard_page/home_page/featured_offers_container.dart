import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedOffersContainer extends StatelessWidget {
  final void Function(String) onPress;
  final Map<BigInt, IOfferEntry> offers;
  final bool isLoading;
  const FeaturedOffersContainer(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Featured rewards', style: texts.headlineLarge),
                RippleWrapper(
                  onPressed: () {
                    dashboardController.setActivePage(2);
                  },
                  child: Row(
                    spacing: 4,
                    children: [
                      Text('See all',
                          style:
                              TextStyle(color: colors.secondary, fontSize: 14)),
                      SvgPicture.asset(
                        'assets/svg/arrowSend.svg',
                        colorFilter:
                            ColorFilter.mode(colors.secondary, BlendMode.srcIn),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: offersList.length,
              itemBuilder: (context, index) {
                final offer = offersList[index];
                final imageUrl = offer.partner.image;
                final name = offer.partner.name;
                final description = offer.description;
                final points = offer.points;
                final catchPhrase = offer.catchString;
                if (isLoading) {
                  return Container(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 8,
                        right: index == offersList.length - 1 ? 16 : 8,
                        top: 16,
                        bottom: 16,
                      ),
                      child: UniversalLoaderBox(height: 130, width: 220));
                }
                return RippleWrapper(
                  onPressed: () {
                    onPress(offer.id.toString());
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == offersList.length - 1 ? 16 : 8,
                      top: 16,
                      bottom: 16,
                    ),
                    padding: const EdgeInsets.all(12),
                    width: 220,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          spreadRadius: -5,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ImageComponent(
                              size: 50,
                              borderRadius: 10,
                              image: imageUrl,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: colors.tertiary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colors.secondary.withAlpha(20),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: SvgPicture.asset(
                                          'assets/svg/fire.svg',
                                          width: 14,
                                          colorFilter: ColorFilter.mode(
                                              colors.secondary,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${points.toInt()} points',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colors.tertiaryContainer,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          catchPhrase,
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.tertiaryContainer,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
