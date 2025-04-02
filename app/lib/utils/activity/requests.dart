import 'dart:convert';

import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';

Future<String?> saveTrainingsRequest(
    List<ITrainingEntry>? parsedTrainingData) async {
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

      return res['content'];
    }
  } catch (error) {
    print('Error saving trainings to database $error');
    rethrow;
  }
  return null;
}

Future<List<ITrainingEntry>?> loadTrainingsRequest(
    String userId, int? limit, int? offset) async {
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
        userId: el['user_id'],
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
