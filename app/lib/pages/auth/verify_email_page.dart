import 'package:excerbuys/components/auth_page/logo.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _loadingLogin = false;

  void tryLogin() async {
    try {
      setState(() {
        _loadingLogin = true;
      });

      final UserToVerify? userToVerify = authController.userToVerify;

      if (userToVerify == null) {
        return;
      }

      await authController.logIn(userToVerify.login, userToVerify.password,
          noEmail: true);

      // if after login user is still not verified
      if (authController.userToVerify != null) {
        throw "Still not verified";
      }

      if (mounted) {
        navigateWithClear(route: '/');
      }
    } catch (e) {
      print(e);
      // TODO: Add snackbar
    } finally {
      setState(() {
        _loadingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 15 + layoutController.statusBarHeight,
                bottom: 15 + layoutController.bottomPadding,
                left: HORIZOTAL_PADDING,
                right: HORIZOTAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: SvgPicture.asset('assets/svg/arrowBack.svg',
                          height: 30,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.tertiary,
                              BlendMode.srcIn))),
                ]),
                Expanded(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 200,
                      child: Image(
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDN7nr95kNS8tTWWSGHFHNo7XiZBmSYTYp4QofsRYUfkp2OmVV2c83Qbx0fZEsAdCFBxo&usqp=CAU')),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Check your inbox',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                'Verification email has been sent to your email. Come back here after successful verification to log into the app and start your journey with finfit! ',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: colors.primaryFixedDim),
                          ),
                          TextSpan(
                            text:
                                "Make sure to check the spam folder if you don't see the message.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: colors.error,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ])),
                  ],
                )),
                RippleWrapper(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Resend email',
                        style: TextStyle(
                            color: colors.tertiaryContainer, fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      if (authController.userToVerify != null) {
                        authController.resendVerificationEmail(
                            authController.userToVerify!.userId);
                      }
                    }),
                MainButton(
                    label: 'Continue to app',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    isDisabled: authController.userToVerify == null,
                    loading: _loadingLogin,
                    onPressed: tryLogin),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
