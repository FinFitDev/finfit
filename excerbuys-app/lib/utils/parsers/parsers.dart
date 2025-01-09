import 'dart:ffi';

import 'package:intl/intl.dart';

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
