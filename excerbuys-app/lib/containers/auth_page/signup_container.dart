import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupContainer extends StatefulWidget {
  const SignupContainer({super.key});

  @override
  State<SignupContainer> createState() => _SignupContainerState();
}

class _SignupContainerState extends State<SignupContainer> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          InputWithIcon(
            leftIcon: 'assets/svg/profile.svg',
            placeholder: 'Username',
            onChange: (String val) {
              // print(val);
            },
          ),
          InputWithIcon(
            leftIcon: 'assets/svg/email.svg',
            placeholder: 'Email',
            onChange: (String val) {
              // print(val);
            },
          ),
          InputWithIcon(
            leftIcon: 'assets/svg/padlock.svg',
            placeholder: 'Password',
            onChange: (String val) {
              // print(val);
            },
            isPassword: true,
          ),
          InputWithIcon(
            leftIcon: 'assets/svg/padlock.svg',
            placeholder: 'Repeat password',
            onChange: (String val) {
              // print(val);
            },
            // error: 'Incorrect password',
            isPassword: true,
          ),
        ]),
        MainButton(
            label: 'Sign up',
            backgroundColor: colors.secondary,
            textColor: colors.primary,
            onPressed: () {})
      ],
    );
  }
}
