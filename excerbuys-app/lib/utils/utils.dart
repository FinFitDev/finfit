import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class GeneralUtils {
  static void navigate({required String route, BuildContext? context}) {
    if (context != null) {
      Navigator.pushNamed(context, route);
    } else {
      GeneralConstants.NAVIGATOR_KEY.currentState?.pushNamed(route);
    }
  }

  static void navigateWithClear(
      {required String route, BuildContext? context}) {
    if (context != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
    } else {
      GeneralConstants.NAVIGATOR_KEY.currentState
          ?.pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
    }
  }
}
