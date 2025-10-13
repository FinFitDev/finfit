import 'package:excerbuys/components/main_header/regular_main_header_content.dart';
import 'package:excerbuys/components/main_header/product_owner_header_content.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/animated_switcher_wrapper.dart';
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: MAIN_HEADER_HEIGHT +
                              layoutController.statusBarHeight,
                          child: StreamBuilder<String?>(
                              stream: shopController.selectedProductOwnerStream,
                              builder: (context, ownerSnapshot) {
                                return AnimatedSwitcherWrapper(
                                    duration: 100,
                                    child: ownerSnapshot.data != null &&
                                            pageSnapshot.data == 1
                                        ? ProductOwnerHeaderContent()
                                        : RegularMainHeaderContent());
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
