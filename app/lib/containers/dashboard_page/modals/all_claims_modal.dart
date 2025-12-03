import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/containers/dashboard_page/modals/claim_qrcode_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/offer_info_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/qrcode_modal.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/types/shop/reward.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class AllClaimsModal extends StatefulWidget {
  const AllClaimsModal({super.key});

  @override
  State<AllClaimsModal> createState() => _AllClaimsModalState();
}

class _AllClaimsModalState extends State<AllClaimsModal> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ModalContentWrapper(
      title: 'Claimed discounts',
      onClose: () {
        closeModal(context);
      },
      child: StreamBuilder<IAllClaimsData>(
        stream: claimsController.allClaimsStream,
        initialData: claimsController.allClaims,
        builder: (context, snapshot) {
          final data = snapshot.data ?? claimsController.allClaims;
          final claims = List<IClaimEntry>.from(data.content.values);

          if (data.isLoading && claims.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colors.secondary),
              ),
            );
          }

          if (claims.isEmpty) {
            return Center(
              child: Text(
                'No claimed discounts yet.',
                style: TextStyle(
                  color: colors.tertiaryContainer,
                  fontSize: 14,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            itemCount: claims.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final claim = claims[index];
              return _ClaimCard(
                key: ValueKey(claim.code),
                entry: claim,
              );
            },
          );
        },
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final IClaimEntry entry;

  const _ClaimCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isNearlyExpired =
        DateTime.parse(entry.validUntil).difference(DateTime.now()).inDays < 10;

    return GestureDetector(
      onTap: () {
        openModal(
            context,
            ClaimQrcodeModal(
              code: entry.code,
            ));
      },
      child: Container(
        height: 200,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RippleWrapper(
                    onPressed: () {
                      openModal(context, OfferInfoModal(offer: entry.offer));
                    },
                    child: ImageComponent(
                      size: 70,
                      borderRadius: 10,
                      image: entry.offer.partner.image,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.offer.description,
                          style: TextStyle(color: colors.primaryFixedDim),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            PositionWithBackground(
                              name:
                                  'Claimed: ${parseDate(DateTime.parse(entry.createdAt))}',
                              image: 'assets/svg/calendar.svg',
                              imageSize: 16,
                              textStyle: TextStyle(
                                  color: colors.primaryFixedDim, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(child: CopyText(textToCopy: entry.code)),
                      GestureDetector(
                        onTap: () {
                          openLink(entry.offer.partner.link ?? '');
                        },
                        child: IconContainer(
                          icon: 'assets/svg/external.svg',
                          size: 35,
                          borderRadius: 100,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      PositionWithBackground(
                        name:
                            '${isNearlyExpired ? 'Almost expired.' : ''} Expires: ${parseDate(DateTime.parse(entry.validUntil))}',
                        image: 'assets/svg/forbid.svg',
                        textStyle: TextStyle(
                            color: isNearlyExpired
                                ? colors.errorContainer
                                : colors.primaryFixedDim,
                            fontSize: 12),
                        backgroundColor: isNearlyExpired
                            ? colors.errorContainer.withAlpha(20)
                            : colors.tertiary.withAlpha(10),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
