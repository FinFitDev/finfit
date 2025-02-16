import 'package:excerbuys/components/auth_page/buttons_switch.dart';
import 'package:excerbuys/components/auth_page/logo.dart';
import 'package:excerbuys/containers/auth_page/login_container.dart';
import 'package:excerbuys/containers/auth_page/signup_container.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final double height = layoutController.relativeContentHeight;

    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: IntrinsicHeight(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: 15 + layoutController.statusBarHeight,
                          bottom: 15 + layoutController.bottomPadding,
                          left: HORIZOTAL_PADDING,
                          right: HORIZOTAL_PADDING),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/svg/arrowBack.svg',
                                      height: 30,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          BlendMode.srcIn))),
                            ]),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 60),
                                child: Logo()),
                            Expanded(
                                child: StreamBuilder<Object>(
                                    stream:
                                        authController.activeAuthMethodStream,
                                    builder: (context, snapshot) {
                                      return IndexedStack(
                                          index: snapshot.hasData &&
                                                  snapshot.data ==
                                                      AUTH_METHOD.SIGNUP
                                              ? 1
                                              : 0,
                                          children: [
                                            LoginContainer(
                                              logIn: authController.logIn,
                                              useGoogleAuth:
                                                  authController.useGoogleAuth,
                                            ),
                                            SignupContainer(
                                              signUp: authController.signUp,
                                            )
                                          ]);
                                    }))
                          ])),
                ))));
  }
}
