import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/auth_controller/auth_controller.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

enum RESET_PASSWORD_FIELD_TYPE { PASSWORD, PASSWORD_REPEAT }

class ResetPasswordContainer extends StatefulWidget {
  final Future<void> Function(String) resetPassword;

  const ResetPasswordContainer({super.key, required this.resetPassword});

  @override
  State<ResetPasswordContainer> createState() => _ResetPasswordContainerState();
}

class _ResetPasswordContainerState extends State<ResetPasswordContainer> {
  final Map<RESET_PASSWORD_FIELD_TYPE, String> _formFieldsState = {
    RESET_PASSWORD_FIELD_TYPE.PASSWORD: '',
    RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT: ''
  };
  Map<RESET_PASSWORD_FIELD_TYPE, String?> _formErrorsState = {
    RESET_PASSWORD_FIELD_TYPE.PASSWORD: null,
    RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT: null
  };

  bool _loading = false;

  void setErrors() {
    final l10n = context.l10n;
    setState(() {
      final String password =
          _formFieldsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD]!;
      final String passwordRepeat =
          _formFieldsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT]!;

      _formErrorsState = {
        RESET_PASSWORD_FIELD_TYPE.PASSWORD: password.isEmpty
            ? l10n.textValidationPasswordRequired
            : password.length < 5
                ? l10n.textValidationMinChars
                : null,
        RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT:
            password.length >= 5 && password != passwordRepeat
                ? l10n.textValidationPasswordsMismatch
                : null
      };
    });
  }

  Future<void> submitForm(BuildContext context) async {
    try {
      if (_loading) {
        return; // Don't submit if we are loading
      }
      setErrors();

      if (_formErrorsState.values.any((error) => error != null)) {
        return; // Don't submit if there are errors
      }
      setState(() {
        _loading = true;
      });
      await widget.resetPassword(
        _formFieldsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD]!
            .replaceAll(' ', ''),
      );

      if (context.mounted) {
        // if the user has to be verified, go to the verify page
        if (authController.userToVerify != null) {
          navigate(route: '/verify_email', context: context);
        } else {
          navigateWithClear(route: '/', context: context);
        }
      }
    } catch (error) {
      return;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final bool isButtonDisabled = _formErrorsState.values
            .any((value) => value != null && value.isNotEmpty) ||
        _formFieldsState.values.any((value) => value.isEmpty);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            InputWithIcon(
              leftIcon: 'assets/svg/padlock.svg',
              placeholder: l10n.textAuthInputPassword,
              onChange: (String val) {
                setState(() {
                  _formFieldsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD] = val;
                  _formErrorsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD] = null;
                });
              },
              error: _formErrorsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD],
              isPassword: true,
              disabled: _loading,
              borderRadius: 10,
            ),
            SizedBox(
              height: 16,
            ),
            InputWithIcon(
              leftIcon: 'assets/svg/padlock.svg',
              placeholder: l10n.textAuthInputRepeatPassword,
              onChange: (String val) {
                setState(() {
                  _formFieldsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT] =
                      val;
                  _formErrorsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT] =
                      null;
                });
              },
              error:
                  _formErrorsState[RESET_PASSWORD_FIELD_TYPE.PASSWORD_REPEAT],
              isPassword: true,
              disabled: _loading,
              borderRadius: 10,
            ),
          ]),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainButton(
                label: l10n.textSetNewPasswordButton,
                backgroundColor: colors.secondary,
                textColor: colors.primary,
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  submitForm(context);
                },
                isDisabled: isButtonDisabled || _loading,
                loading: _loading,
              )
            ],
          )
        ]);
  }
}
