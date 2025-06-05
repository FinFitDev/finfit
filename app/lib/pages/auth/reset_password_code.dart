import 'package:excerbuys/components/auth_page/logo.dart';
import 'package:excerbuys/components/auth_page/pin_code_input.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordCodePage extends StatefulWidget {
  const ResetPasswordCodePage({super.key});

  @override
  State<ResetPasswordCodePage> createState() => _ResetPasswordCodePageState();
}

class _ResetPasswordCodePageState extends State<ResetPasswordCodePage> {
  bool _loadingVerify = false;
  String? code;
  String? _error;

  void verifyCode() async {
    try {
      setState(() {
        _loadingVerify = true;
      });

      if (code == null || code!.length < 6) {
        return;
      }

      final bool? verified =
          await authController.verifyResetPasswordCode(code!);

      if (verified != true) {
        setState(() {
          _error = 'Invalid code';
        });
        return;
      }

      if (mounted) {
        navigate(route: '/set_new_password');
      }
    } catch (e) {
      // TODO: Add snackbar
    } finally {
      setState(() {
        _loadingVerify = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double height = layoutController.relativeContentHeight;

    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                  children: [
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            closeModal(context);
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
                                  'https://cdn2.iconfinder.com/data/icons/web-set-2/50/123-512.png')),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Reset password',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            width: 340,
                            child: PinCodeInput(
                              error: _error,
                              setCode: (value) {
                                setState(() {
                                  code = value;
                                  _error = null;
                                });
                              },
                            )),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    'The email with the code has been sent to ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: colors.primaryFixedDim),
                              ),
                              TextSpan(
                                text: "jackod@gmail.com",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colors.secondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text:
                                    '. Enter the code above to be able to enter a new password.',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: colors.primaryFixedDim),
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
                          if (authController.resetPasswordUser != null) {
                            authController.sendResetPassword(
                                authController.resetPasswordUser!.email);
                          }
                        }),
                    MainButton(
                        label: 'Confirm code',
                        backgroundColor: colors.secondary,
                        textColor: colors.primary,
                        isDisabled: code == null || code!.length < 6,
                        loading: _loadingVerify,
                        onPressed: verifyCode),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
