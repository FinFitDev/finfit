import 'package:excerbuys/containers/auth_page/reset_password_container.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                            Container(
                                margin: EdgeInsets.only(top: 30, bottom: 60),
                                child: Column(
                                  children: [
                                    Text(
                                      'Set new password',
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Then log in again, and enjoy!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: colors.primaryFixedDim),
                                    ),
                                  ],
                                )),
                            Expanded(
                              child: ResetPasswordContainer(
                                resetPassword: authController.setNewPassword,
                              ),
                            )
                          ])),
                ))));
  }
}
