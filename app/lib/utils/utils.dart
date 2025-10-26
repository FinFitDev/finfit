import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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

void closeModal(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
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

Map<S, T> getTopRecentEntries<S, T extends Object>(Map<S, T>? data,
    int Function(MapEntry<S, T>, MapEntry<S, T>) sortFunc, int n) {
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

int countQuantity<T extends HasQuantity>(List<T> items) {
  return items.fold(0, (count, item) => count + item.quantity);
}

void openLink(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

List<LatLng> decodePolylinePoints(String encoded) {
  List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}

String encodePolylinePoints(List<LatLng> points) {
  int encodeCoordinate(double value) => (value * 1e5).round();

  String encode(int coordinate) {
    int coord = coordinate;
    coord = coord < 0 ? ~(coord << 1) : (coord << 1);
    StringBuffer encoded = StringBuffer();
    while (coord >= 0x20) {
      encoded.writeCharCode((0x20 | (coord & 0x1f)) + 63);
      coord >>= 5;
    }
    encoded.writeCharCode(coord + 63);
    return encoded.toString();
  }

  StringBuffer result = StringBuffer();
  int lastLat = 0, lastLng = 0;

  for (LatLng point in points) {
    int lat = encodeCoordinate(point.latitude);
    int lng = encodeCoordinate(point.longitude);

    int dLat = lat - lastLat;
    int dLng = lng - lastLng;

    result.write(encode(dLat));
    result.write(encode(dLng));

    lastLat = lat;
    lastLng = lng;
  }

  return result.toString();
}

double calculateHaversineDistance(
    double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000.0; // meters

  final dLat = toRadians(lat2 - lat1);
  final dLon = toRadians(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(toRadians(lat1)) *
          cos(toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double toRadians(double degrees) {
  return degrees * pi / 180;
}

double calculateWorkoutCalories({
  required double distanceMeters,
  required double durationSeconds,
  required double elevationChangeMeters,
  required ACTIVITY_TYPE type,
}) {
  if (distanceMeters <= 0 || durationSeconds <= 0) return 0.0;

  final double distanceKm = distanceMeters / 1000.0;
  final double durationMin = durationSeconds / 60.0;
  final double durationHours = durationSeconds / 3600.0;

  // Base calorie factors (per km)
  const double runBaseKm = 60.0; // calories per km
  const double walkBaseKm = 40.0;
  const double bikeBaseKm = 25.0;

  // Elevation factor (extra calories per meter climbed)
  const double runElevationFactor = 0.5;
  const double walkElevationFactor = 0.3;
  const double bikeElevationFactor = 0.2;

  // Pace/speed normalization
  const double runPaceWeight = 6.0;
  const double walkPaceWeight = 20.0;
  const double bikeBaselineKmh = 25.0;

  const double runIntensityMin = 0.5;
  const double runIntensityMax = 2.0;
  const double walkIntensityMin = 0.4;
  const double walkIntensityMax = 1.3;
  const double bikeIntensityMin = 0.4;
  const double bikeIntensityMax = 1.6;

  double intensity;
  double baseKmFactor;
  double elevationFactor;

  switch (type) {
    case ACTIVITY_TYPE.Run:
      final double paceMinPerKm = durationMin / distanceKm;
      intensity = (runPaceWeight / paceMinPerKm)
          .clamp(runIntensityMin, runIntensityMax);
      baseKmFactor = runBaseKm;
      elevationFactor = runElevationFactor;
      break;
    case ACTIVITY_TYPE.Ride:
      final double speedKmh =
          distanceKm / (durationHours > 0 ? durationHours : 1e-6);
      intensity = (speedKmh / bikeBaselineKmh)
          .clamp(bikeIntensityMin, bikeIntensityMax);
      baseKmFactor = bikeBaseKm;
      elevationFactor = bikeElevationFactor;
      break;
    case ACTIVITY_TYPE.Walk:
    default:
      final double paceMinPerKm = durationMin / distanceKm;
      intensity = (walkPaceWeight / paceMinPerKm)
          .clamp(walkIntensityMin, walkIntensityMax);
      baseKmFactor = walkBaseKm;
      elevationFactor = walkElevationFactor;
      break;
  }

  // Calories = distance calories + elevation calories
  double calories = (distanceKm * baseKmFactor * intensity) +
      (elevationChangeMeters * elevationFactor);

  // Optional small adjustment for very long workouts
  if (durationHours >= 3) {
    calories *= 0.95; // slight fatigue adjustment
  }

  return double.parse(calories.toStringAsFixed(1));
}

double calcluateTotalElevationChange(List<Position> positions) {
  double gain = 0;
  double loss = 0;

  for (int i = 1; i < positions.length; i++) {
    double delta = positions[i].altitude - positions[i - 1].altitude;
    if (delta > 0) {
      gain += delta;
    } else if (delta < 0) {
      loss += -delta;
    }
  }

  return gain + loss;
}
