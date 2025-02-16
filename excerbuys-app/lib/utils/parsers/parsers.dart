import 'dart:ffi';

import 'package:intl/intl.dart';

String weekDayToName(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Unknown';
  }
}

String padTimeString(String value) {
  return value.padLeft(2, '0');
}

String parseDate(DateTime date) {
  final DateTime now = DateTime.now();

  if (date.year == now.year && date.month == now.month) {
    if (date.day == now.day) {
      return "Today ${padTimeString(date.hour.toString())}:${padTimeString(date.minute.toString())}";
    }

    if (date.day == now.day - 1) {
      return "Yesterday ${padTimeString(date.hour.toString())}:${padTimeString(date.minute.toString())}";
    }
  }

  return "${padTimeString(date.day.toString())} ${DateFormat('MMM').format(date)} ${padTimeString(date.hour.toString())}:${padTimeString(date.minute.toString())}";
}

String padPriceDecimals(double price) {
  var parts = price.toString().split('.');
  String? main = parts[0];
  String? decimals = parts[1];

  if (decimals.isNotEmpty && int.parse(decimals) != 0) {
    if (decimals.length > 2) {
      decimals = decimals.substring(0, 2);
    }
    return '$main.${decimals.padRight(2, '0')}';
  } else {
    return main;
  }
}

int parseInt(dynamic value) {
  return value is String ? int.parse(value) : value;
}

String getDayName(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return weekDayToName(nDaysAgo.weekday);
}

String convertHourAmPm(int hour) {
  if (hour < 12) {
    return '${padTimeString(hour.toString())}:00 am';
  } else if (hour == 12) {
    return '$hour:00 pm';
  } else {
    return '${padTimeString((hour - 12).toString())}:00 pm';
  }
}

double convertMillisecondsToMinutes(int milliseconds) {
  return milliseconds / 1000 / 60;
}
