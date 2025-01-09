import 'dart:convert';

import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/utils.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class TrainingsController {
  // Stream<Map<int, int>> get userStepsStream =>
  //     _userActivity.stream.map();

  Stream<ContentWithLoading<Map<String, ITrainingEntry>>>
      get userTrainingStream => activityController.userActivityStream;

  Future<void> fetchTrainings() async {
    // final lastUpdated = userController.currentUser?.updatedAt;
    final now = DateTime.now();
    // final Duration difference = now.difference(lastUpdated!);

    final yesterday = now.subtract(Duration(days: 30));

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: yesterday,
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

      activityController.addUserActivity(values);
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
  }

  Future<void> saveTrainings(List<ITrainingEntry>? parsedTrainingData) async {
    try {
      if (parsedTrainingData != null) {
        final serializedData =
            jsonEncode(parsedTrainingData.map((el) => el.toJson()).toList());

        await handleBackendRequests(
            method: HTTP_METHOD.POST,
            endpoint: 'api/v1/trainings',
            body: {"trainings": serializedData});
      }
    } catch (error) {
      print('Error saving trainings to database $error');
      rethrow;
    }
  }

  Future<List<ITrainingEntry>?> loadTrainings(
      int userId, int? limit, int? offset) async {
    final List<ITrainingEntry> result = [];
    try {
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/trainings/$userId?limit=$limit&offset=$offset',
      );
      final List content = res['content'];
      for (final el in content) {
        result.add(ITrainingEntry(
          uuid: el['uuid'],
          points: parseInt(el['points']),
          type: el['type'],
          userId: parseInt(el['user_id']),
          duration: parseInt(el['duration']),
          calories: parseInt(el['calories']),
          distance: parseInt(el['distance']),
          createdAt: DateTime.parse(el['created_at']).toLocal(),
        ));
      }
      return result;
    } catch (error) {
      print('Error saving trainings to database $error');
      rethrow;
    }
  }
}

TrainingsController trainingsController = TrainingsController();
