import 'package:excerbuys/components/main_header/regular_main_header_content.dart';
import 'package:excerbuys/components/main_header/product_owner_header_content.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/animated_switcher_wrapper.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatefulWidget {
  const MainHeader({super.key});

  @override
  State<MainHeader> createState() => _MainHeaderState();
}

class _MainHeaderState extends State<MainHeader> {
  int? _lastPage;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return StreamBuilder(
        stream: dashboardController.activePageStream,
        builder: (context, pageSnapshot) {
          return StreamBuilder<double>(
              stream: dashboardController.scrollDistanceStream,
              builder: (context, snapshot) {
                final bool isActive =
                    snapshot.hasData && snapshot.data! > 380 ||
                        pageSnapshot.data != 0;
                final bool isPageChanged =
                    _lastPage != null && _lastPage != pageSnapshot.data;

                if (pageSnapshot.hasData) {
                  _lastPage = pageSnapshot.data as int;
                }

                return AnimatedPositioned(
                  top: isActive ? 0 : -70,
                  duration:
                      Duration(milliseconds: isPageChanged == true ? 0 : 200),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: isActive ? 1 : 0,
                        duration: Duration(
                            milliseconds: isPageChanged == true ? 0 : 100),
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
