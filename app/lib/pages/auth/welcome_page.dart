import 'package:excerbuys/components/rive/logo_rive.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final welcomeTitle = l10n.textWelcomeTitle(l10n.appTitle);
    final titleParts = welcomeTitle.split(l10n.appTitle);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 75 + layoutController.statusBarHeight,
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
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withAlpha(50),
                        //     spreadRadius: -5,
                        //     blurRadius: 8,
                        //     offset: Offset(0, 3),
                        //   ),
                        // ],
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover, // optional: cover, contain, etc.
                        ),
                      ),
                    ), // LogoRive(),
                    SizedBox(
                      height: 24,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: titleParts.isNotEmpty ? titleParts.first : '',
                            style: TextStyle(color: colors.tertiary),
                          ),
                          TextSpan(
                            text: l10n.appTitle,
                            style: TextStyle(color: colors.secondary),
                          ),
                          if (titleParts.length > 1)
                            TextSpan(
                              text: titleParts.sublist(1).join(l10n.appTitle),
                              style: TextStyle(color: colors.tertiary),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      l10n.textWelcomeSubtitle,
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
                    label: l10n.actionSignUp,
                    backgroundColor: colors.tertiaryContainer.withAlpha(50),
                    textColor: colors.primaryFixedDim,
                    onPressed: () {
                      authController.setActiveAuthMethod(AUTH_METHOD.SIGNUP);
                      navigate(route: '/login');
                    }),
                SizedBox(
                  height: 16,
                ),
                MainButton(
                    label: l10n.actionLogIn,
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
