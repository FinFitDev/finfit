import 'package:excerbuys/components/shared/postition.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/containers/dashboard_page/modals/regenerate_image_modal.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

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
                        seed: userController.currentUser?.image, size: 170);
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
            height: 24,
          ),
          Wrap(
            runSpacing: 6,
            children: [
              Postition(
                label: 'Personal details',
                onPressed: () {},
                iconRight: 'assets/svg/arrow-right.svg',
              ),
              Postition(
                label: 'Contracts',
                onPressed: () {},
                iconRight: 'assets/svg/arrow-right.svg',
              ),
              Postition(
                label: 'Recommend',
                onPressed: () {},
              ),
              Postition(
                label: 'Rate the app',
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(children: [
            Text(
              'Settings',
              style: texts.headlineMedium
                  ?.copyWith(color: colors.tertiaryContainer),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Container(
              height: 0.5,
              color: colors.tertiaryContainer,
            ))
          ]),
          SizedBox(
            height: 16,
          ),
          Wrap(
            runSpacing: 6,
            children: [
              Postition(
                label: 'Language',
                onPressed: () {},
                iconRight: 'assets/svg/arrow-right.svg',
                iconLeft: 'assets/svg/language.svg',
              ),
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
