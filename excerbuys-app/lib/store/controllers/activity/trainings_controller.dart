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
    // final lastUpdated = userController.currentUser?.updatedAt;
    final now = DateTime.now();
    // final Duration difference = now.difference(lastUpdated!);

    final prev = now.subtract(Duration(days: 30));

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: prev,
        endTime: now,
      );
      healthData = filterTrainings(Health().removeDuplicates(healthData));

      List<ITrainingEntry> parsedTrainingData =
          convertTrainingsToRequest(healthData) ?? [];

      await saveTrainings(parsedTrainingData);

      if (parsedTrainingData.length < 5 &&
          userController.currentUser?.id != null) {
        parsedTrainingData =
            await loadTrainings(userController.currentUser!.id, 3, 0) ?? [];
      }

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
      };

      addUserTrainings(values);
      setTrainingsLoading(false);
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
  }
}

TrainingsController trainingsController = TrainingsController();
