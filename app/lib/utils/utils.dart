import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';

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

void triggerVibrate(FeedbackType feedback) async {
  bool canVibrate = await Vibrate.canVibrate;
  if (canVibrate) {
    Vibrate.feedback(feedback); // Different vibration types
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel(); // Cancel the previous timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

bool isNetworkImage(String imageUrl) {
  return imageUrl.contains('http://') || imageUrl.contains('https://');
}

Map<String, T> getTopRecentEntries<T extends Object>(Map<String, T>? data,
    int Function(MapEntry<String, T>, MapEntry<String, T>) sortFunc, int n) {
  if (data == null) return {};

  final entries = data.entries.toList()..sort(sortFunc);

  return Map.fromEntries(entries.take(n));
}

Map<String, T> getFilteredEntries<T extends Object>(
    Map<String, T>? data, bool Function(MapEntry<String, T>) filterFunc) {
  if (data == null) return {};

  final entries = data.entries.toList().where(filterFunc);

  return Map.fromEntries(entries);
}

class Nullable<T> {
  final bool isPresent;
  final T? value;

  const Nullable.absent()
      : isPresent = false,
        value = null;

  const Nullable.present(this.value) : isPresent = true;
}

String capitalizeWord(String word) {
  if (word.isEmpty) return word;
  return '${word[0].toUpperCase()}${word.substring(1)}';
}

Map<String, T> lowercaseKeys<T>(Map<String, T> map) {
  return Map.fromEntries(
    map.entries.map((entry) => MapEntry(entry.key.toLowerCase(), entry.value)),
  );
}

void launchURL(String urlString) async {
  final url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
