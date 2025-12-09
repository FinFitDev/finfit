import 'package:excerbuys/components/shared/positions/strava_toggle_position.dart';
import 'package:excerbuys/components/shared/postition.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/containers/dashboard_page/modals/regenerate_image_modal.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/strava_controller/strava_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme texts = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: layoutController.statusBarHeight + MAIN_HEADER_HEIGHT,
          bottom: APPBAR_HEIGHT + layoutController.bottomPadding,
          left: HORIZOTAL_PADDING,
          right: HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 24,
          ),
          Center(
            child: RippleWrapper(
              onPressed: () {
                openModal(context, RegenerateImageModal());
              },
              child: StreamBuilder<User?>(
                  stream: userController.currentUserStream,
                  builder: (context, userSnapshot) {
                    return ProfileImageGenerator(
                      seed: userController.currentUser?.image,
                      size: 130,
                      username: userController.currentUser?.username ?? '',
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            userController.currentUser!.username,
            style: texts.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            userController.currentUser!.email,
            style:
                texts.headlineMedium?.copyWith(color: colors.primaryFixedDim),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 32,
          ),
          Wrap(
            runSpacing: 6,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.secondary,
                      colors.secondary.withAlpha(150),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total points earned',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.primary.withAlpha(200)),
                            ),
                            StreamBuilder<double?>(
                                stream:
                                    userController.userTotalPointsEarnedStream,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data == null
                                        ? '0'
                                        : formatNumber(snapshot.data!.round()),
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        'assets/svg/trend_up.svg',
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                            colors.primary.withAlpha(200), BlendMode.srcIn),
                        width: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Wrap(
            runSpacing: 6,
            children: [
              StreamBuilder<bool>(
                  stream: stravaController.authorizedStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return StravaTogglePosition();
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
              Postition(
                label: 'Contact us',
                onPressed: () {},
                iconLeft: 'assets/svg/phone.svg',
              ),
              Postition(
                label: 'Log out',
                onPressed: () async {
                  await authController.logOut();
                  navigateWithClear(route: '/welcome');
                  dashboardController.reset();
                  activityController.reset();
                  stravaController.reset();
                },
                color: colors.error,
                iconLeft: 'assets/svg/logout.svg',
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
