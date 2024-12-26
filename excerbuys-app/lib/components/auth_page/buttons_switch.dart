import 'package:excerbuys/components/shared/buttons/text_button.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class ButtonSwitch extends StatelessWidget {
  const ButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double width = MediaQuery.sizeOf(context).width;

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: StreamBuilder<Object>(
          stream: authController.activeAuthMethodStream,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                            onPressed: () {
                              authController
                                  .setActiveAuthMethod(AUTH_METHOD.LOGIN);
                            },
                            isActive: snapshot.hasData &&
                                snapshot.data == AUTH_METHOD.LOGIN,
                            text: 'Log in'),
                      ),
                      Expanded(
                        child: CustomTextButton(
                            onPressed: () {
                              authController
                                  .setActiveAuthMethod(AUTH_METHOD.SIGNUP);
                            },
                            isActive: snapshot.hasData &&
                                snapshot.data == AUTH_METHOD.SIGNUP,
                            text: 'Sign up'),
                      )
                    ],
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    left:
                        snapshot.hasData && snapshot.data == AUTH_METHOD.SIGNUP
                            ? width / 2
                            : 22,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.secondary),
                      width: width / 2 - 65,
                      height: 3,
                    ))
              ],
            );
          }),
    );
  }
}
