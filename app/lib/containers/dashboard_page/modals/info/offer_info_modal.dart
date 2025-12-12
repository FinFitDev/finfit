import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_title.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class OfferInfoModal extends StatefulWidget {
  final IOfferEntry offer;
  const OfferInfoModal({super.key, required this.offer});

  @override
  State<OfferInfoModal> createState() => _OfferInfoModalState();
}

class _OfferInfoModalState extends State<OfferInfoModal> {
  bool _isClaiming = false;
  bool? _isSuccess = null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return ModalContentWrapper(
      title: '${widget.offer.partner.name} - ${widget.offer.catchString}',
      padding: EdgeInsets.only(
          bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
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
                  Container(
                    height: 180,
                    color: colors.primary,
                    child: ImageBox(
                      image: widget.offer.image ??
                          widget.offer.partner.bannerImage,
                      placeholderImage:
                          'https://img.freepik.com/vector-premium/resumen-estetica-mediados-siglo-moderno-paisaje-oceanico-plantilla-portada-poster-boho-contemporaneo-ilustraciones-minimas-naturales-arte-impreso-postal-papel-tapiz-arte-pared_13824-550.jpg',
                      borderRadius: 0,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: HORIZOTAL_PADDING),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ImageComponent(
                              size: 60,
                              borderRadius: 10,
                              image: widget.offer.partner.image,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.offer.partner.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: colors.tertiary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.offer.description,
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
                          height: 16,
                        ),
                        StreamBuilder<double?>(
                            stream: userController.userBalanceStream,
                            builder: (context, snapshot) {
                              final bool hasEnoughPoints =
                                  (snapshot.data ?? 0) >= widget.offer.points;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.textCost,
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
                                        l10n.textPointsValue(widget
                                            .offer.points
                                            .toInt()
                                            .toString()),
                                        style: TextStyle(
                                          fontSize: 20,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    colors.error.withAlpha(20),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                l10n.textNotEnoughPoints,
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
                        SizedBox(
                          height: 16,
                        ),
                        PositionWithTitle(
                          title: l10n.textValidUntil,
                          value: parseDate(
                              DateTime.parse(widget.offer.validUntil), l10n),
                          icon: 'assets/svg/clock.svg',
                        ),
                        PositionWithTitle(
                          title: l10n.textClaimedByOthers,
                          value: l10n.textTimesValue(
                              widget.offer.totalRedeemed.toString()),
                          icon: 'assets/svg/gift.svg',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.offer.details,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: colors.tertiaryContainer, fontSize: 12),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: StreamBuilder<double?>(
                stream: userController.userBalanceStream,
                builder: (context, snapshot) {
                  final bool hasEnoughPoints =
                      (snapshot.data ?? 0) >= widget.offer.points;
                  return MainButton(
                      label: l10n.actionClaim,
                      icon: 'assets/svg/gift.svg',
                      backgroundColor: colors.secondary,
                      isDisabled: !hasEnoughPoints,
                      textColor: colors.primary,
                      loading: _isClaiming,
                      isSuccess: !_isClaiming && _isSuccess == true,
                      isError: !_isClaiming && _isSuccess == false,
                      onPressed: () async {
                        setState(() {
                          _isClaiming = true;
                        });
                        final bool response =
                            await claimsController.claimReward(widget.offer.id);

                        setState(() {
                          _isSuccess = response;
                          _isClaiming = false;
                        });
                        await Future.delayed(Duration(milliseconds: 1500));
                        setState(() {
                          _isSuccess = null;
                        });
                      });
                }),
          )
        ],
      ),
    );
  }
}
