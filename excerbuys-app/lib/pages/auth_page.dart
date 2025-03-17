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
    final ColorScheme colors = Theme.of(context).colorScheme;

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
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

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
                            StreamBuilder<AUTH_METHOD>(
                                stream: authController.activeAuthMethodStream,
                                builder: (context, snapshot) {
                                  return Container(
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 60),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data == AUTH_METHOD.LOGIN
                                                ? 'Log in below'
                                                : 'Sign up below',
                                            style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data == AUTH_METHOD.LOGIN
                                                ? 'And continue your journey with FinFit'
                                                : 'And start your journey with FinFit',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                color: colors.primaryFixedDim),
                                          ),
                                        ],
                                      ));
                                }),
                            Expanded(
                                child: StreamBuilder<AUTH_METHOD>(
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
