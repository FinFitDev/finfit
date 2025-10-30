import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
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

    return RippleWrapper(
      onPressed: () {
        openModal(context, OfferInfoModal(offer: entry.offer));
      },
      child: Container(
        height: 325,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                height: 100,
                color: colors.primary,
                child: ImageBox(
                  image: entry.offer.partner.bannerImage,
                  borderRadius: 0,
                ),
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
                          image: entry.offer.partner.image,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.offer.partner.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: colors.tertiary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      entry.offer.catchString,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colors.tertiaryContainer,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              RippleWrapper(
                                onPressed: () {
                                  openLink(entry.offer.partner.link ?? '');
                                },
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Text(
                                      'Visit shop',
                                      style: TextStyle(
                                          color: colors.secondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                    RippleWrapper(
                                      onPressed: () {},
                                      child: SvgPicture.asset(
                                        'assets/svg/external.svg',
                                        colorFilter: ColorFilter.mode(
                                          colors.secondary,
                                          BlendMode.srcIn,
                                        ),
                                        width: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(child: CopyText(textToCopy: entry.code)),
                        GestureDetector(
                            child: SvgPicture.asset(
                              'assets/svg/qrcode.svg',
                              colorFilter: ColorFilter.mode(
                                  colors.primaryFixedDim, BlendMode.srcIn),
                            ),
                            onTap: () {
                              openModal(
                                  context,
                                  ClaimQrcodeModal(
                                    code: entry.code,
                                  ));
                            })
                      ],
                    ),
                    // RippleWrapper(
                    //   onPressed: () {
                    //     Clipboard.setData(ClipboardData(text: entry.code));
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.all(16),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: colors.tertiary.withAlpha(10),
                    //     ),
                    //     child: Row(
                    //       spacing: 16,
                    //       children: [
                    //         Expanded(
                    //           child: Text(
                    //             entry.code,
                    //             style: TextStyle(
                    //               color: colors.tertiary,
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //             softWrap: true,
                    //             overflow: TextOverflow.visible,
                    //           ),
                    //         ),
                    //         SvgPicture.asset(
                    //           'assets/svg/copy.svg',
                    //           colorFilter: ColorFilter.mode(
                    //             colors.tertiary,
                    //             BlendMode.srcIn,
                    //           ),
                    //           width: 24,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Claimed at',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.tertiaryContainer,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              parseDate(DateTime.parse(entry.createdAt)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.tertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Expires',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.tertiaryContainer,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              parseDate(DateTime.parse(entry.validUntil)),
                              style: TextStyle(
                                fontSize: 14,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
