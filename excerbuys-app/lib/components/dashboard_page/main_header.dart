import 'dart:math';
import 'dart:ui';

import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<double>(
        stream: dashboardController.scrollDistanceStream,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: dashboardController.activePageStream,
              builder: (context, pageSnapshot) {
                final bool isActive =
                    snapshot.hasData && snapshot.data! > 150 ||
                        pageSnapshot.data != 0;

                return AnimatedPositioned(
                  top: isActive ? 0 : -50,
                  duration: const Duration(milliseconds: 200),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: isActive ? 1 : 0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: HORIZOTAL_PADDING * 2,
                              right: HORIZOTAL_PADDING * 2,
                              top: layoutController.statusBarHeight),
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            border: Border(
                                bottom:
                                    BorderSide(color: colors.primaryFixedDim)),
                            // boxShadow: isActive
                            //     ? [
                            //         BoxShadow(
                            //           color: Colors.black.withAlpha(20),
                            //           spreadRadius: 3,
                            //           blurRadius: 3,
                            //           offset: Offset(
                            //               0, 3), // changes position of shadow
                            //         ),
                            //       ]
                            //     : [],
                          ),
                          height: 50 + layoutController.statusBarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder<double?>(
                                  stream: userController.userBalanceStream,
                                  builder: (context, snapshot) {
                                    return Text(
                                      dashboardController.balanceHidden
                                          ? '****** finpoints'
                                          : '${(snapshot.data ?? 0).round()} finpoints',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: colors.primaryFixedDim
                                              .withAlpha(isActive ? 255 : 0)),
                                    );
                                  })
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
