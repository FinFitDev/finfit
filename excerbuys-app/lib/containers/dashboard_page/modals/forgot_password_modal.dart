import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/user/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  String _email = "";
  RESET_PASSWORD_ERROR? error;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
              color: colors.primary,
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
              child: Wrap(
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ModalHeader(
                      title: 'Forgot password',
                      subtitle: 'Reset it in the email inbox'),
                  InputWithIcon(
                    error: error != null
                        ? error == RESET_PASSWORD_ERROR.WRONG_EMAIL
                            ? 'Wrong email'
                            : 'Server error'
                        : null,
                    placeholder: 'Enter email',
                    onChange: (val) {
                      setState(() {
                        _email = val;
                        error = null;
                      });
                    },
                    borderRadius: 10,
                    verticalPadding: 12,
                  ),
                  Container(
                    height: 8,
                  ),
                  MainButton(
                      isDisabled:
                          _email.isEmpty || !EMAIL_REGEX.hasMatch(_email),
                      label: 'Send email',
                      backgroundColor: colors.secondary,
                      textColor: colors.primary,
                      onPressed: () async {
                        if (_email.isNotEmpty && EMAIL_REGEX.hasMatch(_email)) {
                          final response =
                              await authController.resetPassword(_email);

                          if (response != null) {
                            setState(() {
                              error = response;
                            });
                          }
                        }
                      }),
                ],
              ))),
    );
  }
}
