import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

void navigate({required String route, BuildContext? context}) {
  if (context != null) {
    Navigator.pushNamed(context, route);
  } else {
    NAVIGATOR_KEY.currentState?.pushNamed(route);
  }
}

void navigateWithClear({required String route, BuildContext? context}) {
  if (context != null) {
    Navigator.pushNamedAndRemoveUntil(
        context, route, (Route<dynamic> route) => false);
  } else {
    NAVIGATOR_KEY.currentState
        ?.pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
  }
}

DateTime constructHourlyTimestamp(DateTime timestamp) {
  return DateTime(
    timestamp.year,
    timestamp.month,
    timestamp.day,
    timestamp.hour, // Keep the hour
    0, // Set minutes to 0
    0, // Set seconds to 0
  );
}

DateTime constructDailyTimestamp(DateTime timestamp) {
  return DateTime(
    timestamp.year,
    timestamp.month,
    timestamp.day,
    0, // Keep the hour
    0, // Set minutes to 0
    0, // Set seconds to 0
  );
}
