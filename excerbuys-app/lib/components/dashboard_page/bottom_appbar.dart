import 'dart:ui';

import 'package:excerbuys/components/shared/buttons/appbar_icon_button.dart';
import 'package:excerbuys/pages/sub/home_page.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Container(
          height: 80 + layoutController.bottomPadding,
          padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: layoutController.bottomPadding,
              top: 16),
          color: Colors.black.withAlpha(200),
          child: StreamBuilder<int>(
              stream: dashboardController.activePageStream,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.elasticOut,
                        left: MediaQuery.sizeOf(context).width / 2 -
                            24 - // padding
                            145 +
                            ((snapshot.data ?? 0) * 80),
                        top: 5,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppbarIconButton(
                          icon: 'assets/svg/home.svg',
                          onPressed: () {
                            dashboardController.setActivePage(0);
                          },
                          isActive: snapshot.data == 0,
                        ),
                        AppbarIconButton(
                          icon: 'assets/svg/search.svg',
                          onPressed: () {
                            dashboardController.setActivePage(1);
                          },
                          isActive: snapshot.data == 1,
                        ),
                        AppbarIconButton(
                          icon: 'assets/svg/tag.svg',
                          onPressed: () {
                            dashboardController.setActivePage(2);
                          },
                          isActive: snapshot.data == 2,
                        ),
                        AppbarIconButton(
                          icon: 'assets/svg/profile.svg',
                          onPressed: () {
                            dashboardController.setActivePage(3);
                          },
                          padding: 20,
                          isActive: snapshot.data == 3,
                          isLast: true,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
