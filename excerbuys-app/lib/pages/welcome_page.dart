import 'package:excerbuys/components/auth_page/logo.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              bottom: -20,
              child: SvgPicture.asset('assets/svg/welcomePageWater.svg')),
          Padding(
            padding: EdgeInsets.only(
                top: 15 + layoutController.statusBarHeight,
                bottom: 15 + layoutController.bottomPadding,
                left: HORIZOTAL_PADDING,
                right: HORIZOTAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 60, bottom: 20),
                        child: Logo()),
                    Container(
                        height: 300,
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: RiveAnimation.asset(
                          'assets/rive/dolphin.riv',
                          fit: BoxFit.contain,
                        )),
                  ],
                )),
                MainButton(
                    label: 'Log in',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    onPressed: () {
                      authController.setActiveAuthMethod(AUTH_METHOD.LOGIN);
                      navigate(route: '/login');
                    }),
                SizedBox(
                  height: 16,
                ),
                MainButton(
                    label: 'Sign up',
                    backgroundColor: colors.primary,
                    textColor: colors.secondary,
                    onPressed: () {
                      authController.setActiveAuthMethod(AUTH_METHOD.SIGNUP);
                      navigate(route: '/login');
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
