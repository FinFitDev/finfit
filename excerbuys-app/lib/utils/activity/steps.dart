import 'dart:convert';

import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:health/health.dart';

List<IHourlyStepsEntry>? convertStepsToRequest(
    Map<String, HealthDataPoint> stepsData,
    Map<String, ITrainingEntry> trainingsData) {
  final int? userId = userController.currentUser?.id;
  try {
    if (userId == null) {
      throw Exception('Not authorized');
    }
    // refactor the data so that the workout and steps dont overlap and data is in correct format
    var filteredData = filterOverlappingSteps(stepsData, trainingsData);

    // create a map of steps for each hour
    Map<DateTime, int> hourlySteps = {};

    filteredData.forEach((key, dataPoint) {
      DateTime timestamp = constructHourlyTimestamp(dataPoint.dateFrom);

      if (hourlySteps.containsKey(timestamp)) {
        hourlySteps[timestamp] = (hourlySteps[timestamp]! +
                (dataPoint.value as NumericHealthValue).numericValue)
            .round();
      } else {
        hourlySteps[timestamp] =
            (dataPoint.value as NumericHealthValue).numericValue.round();
      }
    });

    return hourlySteps.entries
        .map((data) => IHourlyStepsEntry(
            uuid: "${data.key}_$userId",
            total: data.value,
            timestamp: data.key,
            userId: userId))
        .toList();
  } catch (err) {
    print('Error in convertStepsToRequest $err');
    return null;
  }
}

IStoreStepsData groupStepsData(Map<String, HealthDataPoint> stepsData) {
  if (stepsData.isEmpty) {
    return {};
  }

  final Map<DateTime, List<HealthDataPoint>> groupedByDays = {};
  final IStoreStepsData finalData = {};

  for (var el in stepsData.entries) {
    final DateTime timestamp = constructDailyTimestamp(el.value.dateFrom);
    groupedByDays.putIfAbsent(timestamp, () => []).add(el.value);
  }

  for (var el in groupedByDays.entries) {
    finalData[el.key] = divideStepsIntoHours(el.value);
  }

  return finalData;
}

Map<int, int> divideStepsIntoHours(List<HealthDataPoint> data) {
  // create a map of steps for each hour
  Map<int, int> hourlySteps = {for (int i = 0; i < 24; i++) i: 0};

  for (var dataPoint in data) {
    final int key = dataPoint.dateFrom.hour;
    if (hourlySteps.containsKey(key)) {
      hourlySteps[key] = (hourlySteps[key]! +
              (dataPoint.value as NumericHealthValue).numericValue)
          .round();
    } else {
      hourlySteps[key] =
          (dataPoint.value as NumericHealthValue).numericValue.round();
    }
  }

  return hourlySteps;
}

Map<String, HealthDataPoint> filterOverlappingSteps(
    Map<String, HealthDataPoint> stepsData,
    Map<String, ITrainingEntry> trainingsData) {
  return Map.fromEntries(stepsData.entries.where((entry) {
    final currentValue = entry.value;

    final bool isCorrespondingWorkout = trainingsData.values.any((training) =>
        currentValue.dateFrom.compareTo(training.createdAt) >= 0 &&
        currentValue.dateTo.compareTo(training.createdAt
                .add(Duration(milliseconds: training.duration))) <=
            0 &&
        currentValue.value is NumericHealthValue);

    return !isCorrespondingWorkout;
  }).toList());
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

Future<void> saveStepsData(
    List<IHourlyStepsEntry>? parsedHourlyStepsData) async {
  try {
    if (parsedHourlyStepsData != null) {
      final serializedData =
          jsonEncode(parsedHourlyStepsData.map((el) => el.toJson()).toList());

      final res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'api/v1/steps',
          body: {"steps": serializedData});

      if (res['error'] != null) {
        throw res['error'];
      }
    }
  } catch (error) {
    print('Error saving steps to database $error');
    rethrow;
  }
}

List<IHourlyStepsEntry> getTodaysSteps(List<IHourlyStepsEntry> stepsData) {
  return stepsData
      .where((element) =>
          areDatesEqualRespectToDay(DateTime.now(), element.timestamp))
      .toList()
    ..sort((a, b) =>
        a.timestamp.compareTo(b.timestamp)); // Sort by timestamp (ascending)
}
