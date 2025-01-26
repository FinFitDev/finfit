import 'dart:convert';
import 'dart:io';

import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:health/health.dart';

List<HealthDataPoint> filterTrainings(List<HealthDataPoint> healthData) {
  return List.from(healthData.where(
      (el) => ((el.value as WorkoutHealthValue).totalEnergyBurned ?? 0) > 0));
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

Future<void> saveTrainings(List<ITrainingEntry>? parsedTrainingData) async {
  try {
    if (parsedTrainingData != null) {
      final serializedData =
          jsonEncode(parsedTrainingData.map((el) => el.toJson()).toList());

      final res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'api/v1/trainings',
          body: {"trainings": serializedData});

      if (res['error'] != null) {
        throw res['error'];
      }
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

    if (res['error'] != null) {
      throw res['error'];
    }

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
    print('Error loading trainings from database $error');
    rethrow;
  }
}
