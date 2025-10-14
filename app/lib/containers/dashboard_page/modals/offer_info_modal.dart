import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';

class OfferInfoModal extends StatelessWidget {
  final IOfferEntry offer;
  const OfferInfoModal({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ModalContentWrapper(
      title: 'Offer details',
      subtitle: 'Review & claim',
      onClose: () {
        closeModal(context);
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 200,
                    color: colors.primary,
                    child: ImageBox(
                      image: offer.partner.bannerImage,
                      placeholderImage:
                          'https://img.freepik.com/vector-premium/resumen-estetica-mediados-siglo-moderno-paisaje-oceanico-plantilla-portada-poster-boho-contemporaneo-ilustraciones-minimas-naturales-arte-impreso-postal-papel-tapiz-arte-pared_13824-550.jpg',
                      borderRadius: 16,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      ImageComponent(
                        size: 70,
                        borderRadius: 10,
                        image: offer.partner.image,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.partner.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: colors.tertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              offer.description,
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
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.secondary.withAlpha(20),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      offer.catchString,
                      style: TextStyle(
                          fontSize: 20,
                          color: colors.secondary,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    offer.details,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: colors.tertiaryContainer, fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<double?>(
                      stream: userController.userBalanceStream,
                      builder: (context, snapshot) {
                        final bool hasEnoughPoints =
                            (snapshot.data ?? 0) >= offer.points;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Cost',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.tertiaryContainer,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${offer.points.toInt()} points',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: hasEnoughPoints
                                        ? colors.tertiary
                                        : colors.tertiary.withAlpha(50),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 16),
                                hasEnoughPoints
                                    ? SizedBox.shrink()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: colors.error.withAlpha(20),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Not enough points',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: colors.error,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        );
                      }),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Valid until',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.tertiaryContainer,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            parseDate(DateTime.parse(offer.validUntil)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colors.tertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Redeemed',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.tertiaryContainer,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            '${offer.totalRedeemed.toString()} times',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colors.tertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: MainButton(
                label: 'Claim',
                icon: 'assets/svg/gift.svg',
                backgroundColor: colors.secondary,
                textColor: colors.primary,
                onPressed: () {}),
          )
        ],
      ),
    );
  }
}
