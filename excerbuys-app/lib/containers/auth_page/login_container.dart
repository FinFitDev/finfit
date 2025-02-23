import 'dart:io';

import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LOGIN_FIELD_TYPE { LOGIN, PASSWORD }

class LoginContainer extends StatefulWidget {
  final Future<Map<LOGIN_FIELD_TYPE, String?>?> Function(String, String) logIn;
  final Future<String?> Function(String) useGoogleAuth;

  const LoginContainer(
      {super.key, required this.logIn, required this.useGoogleAuth});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final Map<LOGIN_FIELD_TYPE, String> _formFieldsState = {
    LOGIN_FIELD_TYPE.LOGIN: '',
    LOGIN_FIELD_TYPE.PASSWORD: ''
  };
  Map<LOGIN_FIELD_TYPE, String?> _formErrorsState = {
    LOGIN_FIELD_TYPE.LOGIN: null,
    LOGIN_FIELD_TYPE.PASSWORD: null
  };
  bool _loading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS ? null : WEB_CLIENT_GOOGLE_ID,
      scopes: ['email', 'profile', 'openid']);

  void setErrors() {
    setState(() {
      final String login = _formFieldsState[LOGIN_FIELD_TYPE.LOGIN]!;
      final String password = _formFieldsState[LOGIN_FIELD_TYPE.PASSWORD]!;
      _formErrorsState = {
        LOGIN_FIELD_TYPE.LOGIN: login.isEmpty ? 'Login is required' : null,
        LOGIN_FIELD_TYPE.PASSWORD:
            password.isEmpty ? 'Password is required' : null
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

      final Map<LOGIN_FIELD_TYPE, String?>? serverResponse = await widget.logIn(
          _formFieldsState[LOGIN_FIELD_TYPE.LOGIN]!,
          _formFieldsState[LOGIN_FIELD_TYPE.PASSWORD]!);

      if (serverResponse != null) {
        serverResponse.forEach((key, val) {
          setState(() {
            _formErrorsState[key] = val;
          });
        });
        return;
      }

      if (context.mounted) {
        navigateWithClear(route: '/', context: context);
      }
    } catch (error) {
      return;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      if (_loading) {
        return; // Don't submit if we are loading
      }
      setState(() {
        _loading = true;
      });
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        String idToken = googleAuth.idToken!;

        await widget.useGoogleAuth(idToken);

        if (context.mounted) {
          navigateWithClear(route: '/');
        }
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final bool isButtonDisabled = _formErrorsState.values
            .any((value) => value != null && value.isNotEmpty) ||
        _formFieldsState.values.any((value) => value.isEmpty);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            InputWithIcon(
              leftIcon: 'assets/svg/login.svg',
              placeholder: 'Login',
              onChange: (String val) {
                setState(() {
                  _formFieldsState[LOGIN_FIELD_TYPE.LOGIN] = val;
                  _formErrorsState[LOGIN_FIELD_TYPE.LOGIN] = null;
                });
              },
              error: _formErrorsState[LOGIN_FIELD_TYPE.LOGIN],
              disabled: _loading,
            ),
            SizedBox(
              height: 16,
            ),
            InputWithIcon(
              leftIcon: 'assets/svg/padlock.svg',
              placeholder: 'Password',
              onChange: (String val) {
                setState(() {
                  _formFieldsState[LOGIN_FIELD_TYPE.PASSWORD] = val;
                  _formErrorsState[LOGIN_FIELD_TYPE.PASSWORD] = null;
                });
              },
              error: _formErrorsState[LOGIN_FIELD_TYPE.PASSWORD],
              isPassword: true,
              disabled: _loading,
            ),
            loginOptions(colors),
          ]),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RippleWrapper(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                          color: colors.tertiaryContainer, fontSize: 16),
                    ),
                  ),
                  onPressed: () {}),
              MainButton(
                label: 'Log in',
                backgroundColor: colors.secondary,
                textColor: colors.primary,
                onPressed: () {
                  submitForm(context);
                },
                isDisabled: isButtonDisabled || _loading,
                loading: _loading,
              )
            ],
          )
        ]);
  }

  Widget loginOptions(ColorScheme colors) => Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                margin: EdgeInsets.only(right: Platform.isIOS ? 12 : 0),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: colors.primaryContainer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: signInWithGoogle,
                  label: Text(
                    'Google',
                    style: TextStyle(
                        fontSize: 16,
                        color: colors.tertiary,
                        fontWeight: FontWeight.w500),
                  ),
                  icon: SvgPicture.asset('assets/svg/google.svg'),
                ),
              ),
            ),
            Platform.isIOS
                ? Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.only(right: 15)),
                        onPressed: () {},
                        label: Text(
                          'Apple',
                          style: TextStyle(
                              fontSize: 16,
                              color: colors.primaryContainer,
                              fontWeight: FontWeight.w500),
                        ),
                        icon: SvgPicture.asset('assets/svg/apple.svg'),
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      );
}
