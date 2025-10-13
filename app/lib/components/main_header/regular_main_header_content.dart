import 'package:excerbuys/containers/dashboard_page/modals/cart/cart_modal.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      // RippleWrapper(
      //     child: Container(
      //       padding: EdgeInsets.all(8),
      //       child: SvgPicture.asset(
      //         'assets/svg/bell.svg',
      //         width: 24,
      //       ),
      //     ),
      //     onPressed: () {}),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        StreamBuilder<double?>(
            stream: userController.userBalanceStream,
            builder: (context, snapshot) {
              return Text(
                  dashboardController.balanceHidden
                      ? '****** points total'
                      : '${formatNumber((snapshot.data ?? 0).round())} points total',
                  style: texts.headlineMedium
                      ?.copyWith(color: colors.primaryFixedDim));
            }),
        // StreamBuilder<double?>(
        //     stream: activityController.todaysPointsStream,
        //     builder: (context, snapshot) {
        //       return Text(
        //           dashboardController.balanceHidden
        //               ? '****** finpoints today'
        //               : '${formatNumber(snapshot.data?.round() ?? 0)} finpoints today',
        //           style:
        //               TextStyle(fontSize: 13, color: colors.tertiaryContainer));
        //     }),
      ]),
    ]);
  }
}
