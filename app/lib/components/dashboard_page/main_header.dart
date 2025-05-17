import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return StreamBuilder<double>(
        stream: dashboardController.scrollDistanceStream,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: dashboardController.activePageStream,
              builder: (context, pageSnapshot) {
                final bool isActive =
                    snapshot.hasData && snapshot.data! > 380 ||
                        pageSnapshot.data != 0;

                return AnimatedPositioned(
                  top: isActive ? 0 : -70,
                  duration: const Duration(milliseconds: 200),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: isActive ? 1 : 0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 1.5 * HORIZOTAL_PADDING,
                              right: 1.5 * HORIZOTAL_PADDING,
                              top: layoutController.statusBarHeight),
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            border: Border(
                                bottom: BorderSide(
                                    color: colors.primaryFixedDim, width: 0.5)),
                          ),
                          height: MAIN_HEADER_HEIGHT +
                              layoutController.statusBarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RippleWrapper(
                                  child: SvgPicture.asset(
                                    'assets/svg/bell.svg',
                                    width: 24,
                                  ),
                                  onPressed: () {}),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double?>(
                                      stream: userController.userBalanceStream,
                                      builder: (context, snapshot) {
                                        return Text(
                                            dashboardController.balanceHidden
                                                ? '****** finpoints total'
                                                : '${formatNumber((snapshot.data ?? 0).round())} finpoints total',
                                            style: texts.headlineMedium
                                                ?.copyWith(
                                                    color: colors
                                                        .primaryFixedDim));
                                      }),
                                  StreamBuilder<double?>(
                                      stream:
                                          activityController.todaysPointsStream,
                                      builder: (context, snapshot) {
                                        return Text(
                                            dashboardController.balanceHidden
                                                ? '****** finpoints today'
                                                : '${formatNumber(snapshot.data?.round() ?? 0)} finpoints today',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    colors.tertiaryContainer));
                                      })
                                ],
                              ),
                              pageSnapshot.data == 1
                                  ? RippleWrapper(
                                      child: SvgPicture.asset(
                                        'assets/svg/cart.svg',
                                        width: 24,
                                      ),
                                      onPressed: () {})
                                  : SizedBox(
                                      width: 24,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
