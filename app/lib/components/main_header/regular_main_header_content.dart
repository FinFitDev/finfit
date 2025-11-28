import 'package:excerbuys/containers/dashboard_page/modals/all_claims_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/cart/cart_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/qrcode_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/send/send_modal.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegularMainHeaderContent extends StatelessWidget {
  const RegularMainHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        StreamBuilder<double?>(
            stream: userController.userBalanceStream,
            builder: (context, snapshot) {
              return Text(
                  dashboardController.balanceHidden
                      ? '****** points'
                      : '${formatNumber((snapshot.data ?? 0).round())} points',
                  style: texts.headlineMedium
                      ?.copyWith(color: colors.primaryFixedDim));
            }),
      ]),
      Row(
        children: [
          RippleWrapper(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/svg/arrowSend.svg',
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          colors.primaryFixedDim, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                openModal(context, SendModal());
              }),
          RippleWrapper(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/svg/qrcode.svg',
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          colors.primaryFixedDim, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                openModal(context, QrcodeModal());
              }),
          StreamBuilder<IAllClaimsData>(
              stream: claimsController.allClaimsStream,
              builder: (context, snapshot) {
                return RippleWrapper(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/svg/gift.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                colors.primaryFixedDim, BlendMode.srcIn),
                          ),
                        ),
                        snapshot.data != null &&
                                snapshot.data!.content.keys.isNotEmpty
                            ? Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: colors.error),
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: Text(
                                      snapshot.data!.content.keys.length
                                          .toString(),
                                      style: TextStyle(
                                          color: colors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9),
                                    ),
                                  ),
                                ))
                            : SizedBox.shrink()
                      ],
                    ),
                    onPressed: () {
                      openModal(context, AllClaimsModal());
                    });
              }),
        ],
      ),
    ]);
  }
}
