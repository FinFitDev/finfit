import 'dart:convert';

import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/selectors/activity/steps.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
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
    final lastUpdated = userController.currentUser?.updatedAt;
    final now = DateTime.now();
    final Duration difference = now.difference(lastUpdated!);
    final Duration maxDifference = Duration(days: 3);
// Use the smaller of the two: the actual difference or 24 hours
    final Duration limitedDifference =
        difference > maxDifference ? maxDifference : difference;

    final prev = now.subtract(maxDifference);

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: prev,
        endTime: now,
      );
      healthData = Health().removeDuplicates(healthData);

      final Map<String, HealthDataPoint> healthDataMap = Map();
      for (var el in healthData) {
        healthDataMap[el.uuid] = el;
      }

      final filteredData = filterOverlappingSteps(
          healthDataMap, trainingsController.userTrainings.content);
      final finalStepsDataInHours = groupStepsData(filteredData);
      addUserSteps(finalStepsDataInHours);
      setStepsLoading(false);

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
