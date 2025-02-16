import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

class StepsController {
  final BehaviorSubject<ContentWithLoading<IStoreStepsData>> _userSteps =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<IStoreStepsData>> get userStepsStream =>
      _userSteps.stream;
  ContentWithLoading<IStoreStepsData> get userSteps => _userSteps.value;
  addUserSteps(IStoreStepsData activity) {
    IStoreStepsData newSteps = {...userSteps.content, ...activity};
    _userSteps.add(ContentWithLoading(content: newSteps));
  }

  setStepsLoading(bool loading) {
    userSteps.isLoading = loading;
    _userSteps.add(userSteps);
  }

  Future<void> fetchsSteps() async {
    final now = DateTime.now();
    final lastUpdated = userController.currentUser?.stepsUpdatedAt ?? now;
    final Duration difference = now.difference(lastUpdated);
    final Duration minDifference = Duration(days: 6);

// Use the larger of the two: the actual difference or 6 days
    final Duration limitedDifference =
        difference < minDifference ? minDifference : difference;

    final prev = now.subtract(limitedDifference);

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: prev,
        endTime: now,
      );
      healthData = Health().removeDuplicates(healthData);

      final Map<String, HealthDataPoint> healthDataMap = {};
      for (var el in healthData) {
        healthDataMap[el.uuid] = el;
      }

      final filteredData = filterOverlappingSteps(
          healthDataMap, trainingsController.userTrainings.content);

      // steps that are not awarded yet
      final newSteps = filteredData.values
          .where((entry) => entry.dateFrom.compareTo(lastUpdated) > 0)
          .toList();

      final finalStepsDataInHours = groupStepsData(filteredData);
      addUserSteps(finalStepsDataInHours);
      setStepsLoading(false);

      int pointsToAdd = newSteps.isNotEmpty
          ? newSteps
              .map((point) =>
                  ((point.value as NumericHealthValue).numericValue * 0.2)
                      .round())
              .reduce((accumulator, current) => accumulator + current)
          : 0;

      // update in db and then compund the points for one animation
      if (pointsToAdd > 0) {
        final bool updateResult =
            await userController.updateUserPointsScoreAndTimestamp(pointsToAdd);
        if (updateResult) {
          activityController.compundPointsToAdd(pointsToAdd.toDouble());
        }
      }

      // final stepsData = convertStepsToRequest(
      //     healthDataMap, trainingsController.userTrainings.content);

      // if (stepsData != null && stepsData.isNotEmpty) {
      //   addUserSteps(Map.fromEntries(
      //     getTodaysSteps(stepsData).map(
      //         (element) => MapEntry("${element.timestamp}", element.total)),
      //   ));
      //   setStepsLoading(false);

      //   saveStepsData(stepsData
      //       .where((el) => el.timestamp.compareTo(lastUpdated) >= 0)
      //       .toList());
      // }

      // List<ITrainingEntry> parsedTrainingData =
      //     convertTrainingsToRequest(healthData) ?? [];

      // await saveTrainings(parsedTrainingData);

      // if (parsedTrainingData.length < 5 &&
      //     userController.currentUser?.id != null) {
      //   parsedTrainingData =
      //       await loadTrainings(userController.currentUser!.id, 3, 0) ?? [];
      // }

      // Map<String, ITrainingEntry> values = {
      //   for (var el in parsedTrainingData) el.uuid: el,
      // };

      // addUserTrainings(values);
      // setTrainingsLoading(false);
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
  }
}

StepsController stepsController = StepsController();
