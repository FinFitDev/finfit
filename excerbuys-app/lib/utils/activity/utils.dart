import 'dart:io';

import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:health/health.dart';

Map<String, HealthDataPoint> filterTrainingData(
    Map<String, HealthDataPoint> data) {
  return Map.fromEntries(data.entries.where((entry) {
    return entry.value.value is WorkoutHealthValue &&
        ((entry.value.value as WorkoutHealthValue).totalEnergyBurned ?? 0) > 0;
  }));
}

List<HealthDataPoint> filterTrainings(List<HealthDataPoint> healthData) {
  return List.from(healthData.where(
      (el) => ((el.value as WorkoutHealthValue).totalEnergyBurned ?? 0) > 0));
}

Map<int, int> parsePassiveSteps(Map<String, HealthDataPoint> data) {
  // refactor the data so that the workout and steps data dont overlap and is in correct format
  // we also want only the data for today
  var filteredActivity = Map.fromEntries(data.entries.where((entry) {
    final currentValue = entry.value;
    final DateTime today = DateTime.now();

    final bool isWorkout = currentValue.value is WorkoutHealthValue;

    final bool isCorrespondingWorkout = data.values.any((point) =>
        currentValue.dateFrom.compareTo(point.dateFrom) >= 0 &&
        currentValue.dateTo.compareTo(point.dateFrom) <= 0 &&
        point.value is WorkoutHealthValue &&
        currentValue.value is NumericHealthValue);

    final bool isToday = areDatesEqualRespectToDay(currentValue.dateTo, today);

    return !isWorkout && !isCorrespondingWorkout && isToday;
  }).toList());

  // create a map of steps for each hour
  Map<int, int> hourlySteps = {};

  filteredActivity.forEach((key, dataPoint) {
    int hour = dataPoint.dateTo.hour;

    if (hourlySteps.containsKey(hour)) {
      hourlySteps[hour] = (hourlySteps[hour]! +
              (dataPoint.value as NumericHealthValue).numericValue)
          .round();
    } else {
      hourlySteps[hour] =
          (dataPoint.value as NumericHealthValue).numericValue.round();
    }
  });

  for (int i = 0; i < 24; i++) {
    if (!hourlySteps.containsKey(i)) {
      hourlySteps[i] = 0;
    }
  }

  final sortedHourlySteps = Map.fromEntries(
      hourlySteps.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  return sortedHourlySteps;
}

bool areDatesEqualRespectToMinutes(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day &&
      date1.hour == date2.hour &&
      date1.minute == date2.minute;
}

bool areDatesEqualRespectToDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

List<ITrainingEntry>? convertTrainingsToRequest(
    List<HealthDataPoint> elements) {
  final List<ITrainingEntry> result = [];
  final int? userId = userController.currentUser?.id;
  try {
    if (userId == null) {
      throw Exception('Not authorized');
    }

    for (final el in elements) {
      final value = el.value as WorkoutHealthValue;

      final ITrainingEntry parsedEl = ITrainingEntry(
          uuid:
              '${Platform.isIOS ? 'ios' : 'android'}_${el.sourceDeviceId}_${el.uuid}',
          points: 200,
          duration: calculateTrainingDuration(el.dateFrom, el.dateTo),
          calories: value.totalEnergyBurned ?? 0,
          distance: value.totalDistance ?? 0,
          type: value.workoutActivityType.name,
          userId: userId,
          createdAt: el.dateTo);

      result.add(parsedEl);
    }

    return result;
  } catch (error) {
    print(error);
    return null;
  }
}

int calculateTrainingDuration(DateTime dateFrom, DateTime dateTo) {
  return dateTo.difference(dateFrom).inMilliseconds;
}
