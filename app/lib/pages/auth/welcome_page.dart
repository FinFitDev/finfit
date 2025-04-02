import 'package:excerbuys/components/rive/logo_rive.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              bottom: -30,
              child: Opacity(
                  opacity: 1,
                  child: SvgPicture.asset('assets/svg/welcomePageWater.svg'))),
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
                    LogoRive(),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: 'Welcome to ',
                                style: TextStyle(color: colors.tertiary),
                              ),
                              TextSpan(
                                text: "FinFit",
                                style: TextStyle(
                                  color: colors.secondary,
                                ),
                              ),
                            ])),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Financing your fitness is now reality",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: colors.primaryFixedDim,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                )),
                MainButton(
                    label: 'Sign up',
                    backgroundColor: colors.primary,
                    textColor: colors.secondary,
                    onPressed: () {
                      authController.setActiveAuthMethod(AUTH_METHOD.SIGNUP);
                      navigate(route: '/login');
                    }),
                SizedBox(
                  height: 16,
                ),
                MainButton(
                    label: 'Log in',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    onPressed: () {
                      authController.setActiveAuthMethod(AUTH_METHOD.LOGIN);
                      navigate(route: '/login');
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
