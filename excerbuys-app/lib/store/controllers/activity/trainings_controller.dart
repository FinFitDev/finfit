import 'dart:convert';

import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/trainings.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

class TrainingsController {
  final BehaviorSubject<ContentWithLoading<Map<String, ITrainingEntry>>>
      _userTrainings = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITrainingEntry>>>
      get usetTrainingsStream => _userTrainings.stream;
  ContentWithLoading<Map<String, ITrainingEntry>> get userTrainings =>
      _userTrainings.value;
  addUserTrainings(Map<String, ITrainingEntry> activity) {
    Map<String, ITrainingEntry> newTrainings = {
      ...userTrainings.content,
      ...activity
    };
    _userTrainings.add(ContentWithLoading(content: newTrainings));
  }

  setTrainingsLoading(bool loading) {
    userTrainings.isLoading = loading;
    _userTrainings.add(userTrainings);
  }

  Future<void> fetchTrainings() async {
    final now = DateTime.now();
    final userCreated = userController.currentUser?.createdAt ?? now;
    final Duration difference = now.difference(userCreated);
    final Duration maxDifference = Duration(days: 90);

    // Use the smaller of the two: the actual difference or 60 days (we only fetch max up to 3 months of tainings backwards)
    final Duration limitedDifference =
        difference > maxDifference ? maxDifference : difference;

    final prev = now.subtract(limitedDifference);

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: prev,
        endTime: now,
      );
      healthData = filterTrainings(Health().removeDuplicates(healthData));

      List<ITrainingEntry> parsedTrainingData =
          convertTrainingsToRequest(healthData) ?? [];

      final pointsAwardedResponse = await saveTrainings(parsedTrainingData);
      if (pointsAwardedResponse != null) {
        activityController
            .compundPointsToAdd(double.parse(pointsAwardedResponse));
      }

      if (userController.currentUser?.id != null) {
        parsedTrainingData =
            await loadTrainings(userController.currentUser!.id, 6, 0) ?? [];

        Set<String> unique = {};
        parsedTrainingData = parsedTrainingData
            .where((element) => unique.add(element.uuid))
            .toList();
      }

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
      };

      addUserTrainings(values);
      setTrainingsLoading(false);
    } catch (error) {
      debugPrint("Exception while extracting trainings data: $error");
    }
  }
}

TrainingsController trainingsController = TrainingsController();
