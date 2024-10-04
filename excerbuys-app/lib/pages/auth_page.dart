import 'package:excerbuys/components/auth_page/buttons_switch.dart';
import 'package:excerbuys/components/auth_page/logo.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/text_button.dart';
import 'package:excerbuys/containers/auth_page/login_container.dart';
import 'package:excerbuys/containers/auth_page/signup_container.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
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
                      padding: EdgeInsets.all(35),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              children: [Logo(), ButtonSwitch()],
                            ),
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
                                            ),
                                            SignupContainer()
                                          ]);
                                    }))
                          ])),
                ))));
  }
}
