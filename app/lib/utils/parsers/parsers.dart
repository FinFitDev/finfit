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

String monthToName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';

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

String parseDateYear(DateTime date) {
  final DateTime now = DateTime.now();

  if (date.year == now.year && date.month == now.month) {
    if (date.day == now.day) {
      return "Today ${date.year}";
    }

    if (date.day == now.day - 1) {
      return "Yesterday ${date.year}";
    }
  }

  return "${padTimeString(date.day.toString())} ${DateFormat('MMM').format(date)} ${date.year}";
}

String padPriceDecimals(double price) {
  var parts = price.toString().split('.');
  String? main = parts[0];
  String? decimals = parts[1];

  if (decimals.isNotEmpty && parseInt(decimals) != 0) {
    if (decimals.length > 2) {
      decimals = decimals.substring(0, 2);
    }
    return '$main.${decimals.padRight(2, '0')}';
  } else {
    return main;
  }
}

int parseInt(dynamic value) {
  return value is String ? int.tryParse(value) : value;
}

String getDayName(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return weekDayToName(nDaysAgo.weekday);
}

String getDayNumber(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return nDaysAgo.day.toString();
}

String getDayMonth(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return monthToName(nDaysAgo.month);
}

String getDayYear(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return nDaysAgo.year.toString();
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

String formatNumber(num number) {
  String formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  return formatted;
}

String parseDuration(int durationMilliseconds) {
  int seconds = durationMilliseconds ~/ 1000;
  if (seconds < 60) {
    return '$seconds second${seconds == 1 ? '' : 's'}';
  }

  int minutes = seconds ~/ 60;
  return '$minutes minute${minutes == 1 ? '' : 's'}';
}

String parseDistance(double meters) {
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)} meter${meters == 1 ? '' : 's'}';
  }

  double kilometers = meters / 1000;
  return '${kilometers.toStringAsFixed(1)} km';
}

String capitalizeFirst(String? text) {
  if (text == null) return '';
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

// String encodeBase36(String input) {
//   BigInt num = BigInt.zero;
//   for (int i = 0; i < input.length; i++) {
//     num = num * BigInt.from(256) + BigInt.from(input.codeUnitAt(i));
//   }
//   return num.toRadixString(36);
// }

// String decodeBase36(String base36) {
//   BigInt num = BigInt.parse(base36, radix: 36);
//   List<int> bytes = [];
//   while (num > BigInt.zero) {
//     bytes.insert(0, (num % BigInt.from(256)).toInt());
//     num = num ~/ BigInt.from(256);
//   }
//   return String.fromCharCodes(bytes);
// }
