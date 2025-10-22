import 'package:excerbuys/components/shared/buttons/appbar_icon_button.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<int>(
        stream: dashboardController.activePageStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Container(
                height: APPBAR_HEIGHT + layoutController.bottomPadding,
                padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: layoutController.bottomPadding,
                    top: 16),
                decoration: BoxDecoration(
                  color: colors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, -3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppbarIconButton(
                      name: 'Home',
                      icon: 'assets/svg/home.svg',
                      onPressed: () {
                        dashboardController.setActivePage(0);
                      },
                      isActive: snapshot.data == 0,
                    ),
                    AppbarIconButton(
                      name: 'Track',
                      icon: 'assets/svg/footprints.svg',
                      onPressed: () {
                        dashboardController.setActivePage(1);
                      },
                      isActive: snapshot.data == 1,
                    ),
                    AppbarIconButton(
                      name: 'Offers',
                      icon: 'assets/svg/gift.svg',
                      onPressed: () {
                        dashboardController.setActivePage(2);
                      },
                      isActive: snapshot.data == 2,
                    ),
                    AppbarIconButton(
                      name: 'Recent',
                      icon: 'assets/svg/clockBold.svg',
                      onPressed: () {
                        dashboardController.setActivePage(3);
                      },
                      isActive: snapshot.data == 3,
                    ),
                    StreamBuilder<User?>(
                        stream: userController.currentUserStream,
                        builder: (context, userSnapshot) {
                          return AppbarIconButton(
                            name: 'Profile',
                            icon: 'assets/svg/profile.svg',
                            isProfile: userSnapshot.hasData,
                            onPressed: () {
                              !userSnapshot.hasData
                                  ? null
                                  : dashboardController.setActivePage(4);
                            },
                            isActive: snapshot.data == 4,
                            isLast: true,
                          );
                        }),
                  ],
                ),
              ),
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.decelerate,
                  left: MediaQuery.sizeOf(context).width / 2 -
                      165 +
                      ((snapshot.data ?? 0) * 70),
                  top: 0,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10), top: Radius.circular(3)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )),
            ],
          );
        });
  }
}
