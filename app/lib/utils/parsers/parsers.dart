import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String padTimeString(String value) {
  return value.padLeft(2, '0');
}

String parseDate(DateTime date, AppLocalizations l10n) {
  final DateTime now = DateTime.now();
  if (date.year != now.year) {
    return parseDateYear(date, l10n);
  } else {
    return parseDateHour(date, l10n);
  }
}

String parseDateHour(DateTime date, AppLocalizations l10n) {
  final DateTime now = DateTime.now();
  final String time =
      DateFormat.Hm(Intl.getCurrentLocale()).format(date.toLocal());

  if (date.year == now.year && date.month == now.month) {
    if (date.day == now.day) {
      return "${l10n.textTodayLabel} $time";
    }

    if (date.day == now.day - 1) {
      return "${l10n.textYesterdayLabel} $time";
    }
  }

  return DateFormat('dd MMM HH:mm', Intl.getCurrentLocale())
      .format(date.toLocal());
}

String parseDateYear(DateTime date, AppLocalizations l10n) {
  final DateTime now = DateTime.now();

  if (date.year == now.year && date.month == now.month) {
    if (date.day == now.day) {
      return "${l10n.textTodayLabel} ${date.year}";
    }

    if (date.day == now.day - 1) {
      return "${l10n.textYesterdayLabel} ${date.year}";
    }
  }

  return DateFormat('dd MMM yyyy', Intl.getCurrentLocale())
      .format(date.toLocal());
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

double? safeParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String getDayName(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return DateFormat('EEEE', Intl.getCurrentLocale()).format(nDaysAgo);
}

String getDayNumber(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return nDaysAgo.day.toString();
}

String getDayMonth(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return DateFormat('MMMM', Intl.getCurrentLocale()).format(nDaysAgo);
}

String getDayYear(int daysAgo) {
  final DateTime now = DateTime.now();
  final DateTime nDaysAgo = now.subtract(Duration(days: daysAgo));
  return nDaysAgo.year.toString();
}

double convertMillisecondsToMinutes(int milliseconds) {
  return milliseconds / 1000 / 60;
}

String formatNumber(num number) {
  String formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  return formatted;
}

String parseDuration(int seconds) {
  if (seconds < 60) {
    return '$seconds s';
  }

  if (seconds < 3600) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return '$minutes m';
    } else {
      return '$minutes m ${remainingSeconds}s';
    }
  }

  int hours = seconds ~/ 3600;
  int remainingSeconds = seconds % 3600;
  int minutes = remainingSeconds ~/ 60;

  if (minutes == 0) {
    return '$hours h';
  } else {
    return '$hours h ${minutes}m';
  }
}

String parseDistance(double meters) {
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)} m';
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
