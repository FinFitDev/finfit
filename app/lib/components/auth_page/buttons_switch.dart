import 'package:excerbuys/components/shared/buttons/text_button.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class ButtonSwitch extends StatelessWidget {
  const ButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double width = MediaQuery.sizeOf(context).width;
    final l10n = context.l10n;

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
                              FocusScope.of(context).unfocus();
                            },
                            isActive: snapshot.hasData &&
                                snapshot.data == AUTH_METHOD.LOGIN,
                            text: l10n.actionLogIn),
                      ),
                      Expanded(
                        child: CustomTextButton(
                            onPressed: () {
                              authController
                                  .setActiveAuthMethod(AUTH_METHOD.SIGNUP);
                              FocusScope.of(context).unfocus();
                            },
                            isActive: snapshot.hasData &&
                                snapshot.data == AUTH_METHOD.SIGNUP,
                            text: l10n.actionSignUp),
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
