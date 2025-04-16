import 'dart:io';
import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:health/health.dart';

List<HealthDataPoint> filterTrainings(List<HealthDataPoint> healthData) {
  return List.from(healthData.where(
      (el) => ((el.value as WorkoutHealthValue).totalEnergyBurned ?? 0) > 0));
}

List<ITrainingEntry>? convertTrainingsToRequest(
    List<HealthDataPoint> elements) {
  final List<ITrainingEntry> result = [];
  final String? userId = userController.currentUser?.uuid;
  try {
    if (userId == null) {
      throw Exception('Not authorized');
    }

    for (final el in elements) {
      final value = el.value as WorkoutHealthValue;
      final ITrainingEntry parsedEl = ITrainingEntry(
          uuid:
              '${Platform.isIOS ? 'ios' : 'android'}_${appController.deviceId}_${el.uuid}',
          // TODO: change calculation
          points: ((value.totalEnergyBurned ?? 0) / 2).round(),
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
