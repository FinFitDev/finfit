import 'dart:convert';

import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

Future<List<int>> saveTrainingsRequest(
    List<ITrainingEntry>? parsedTrainingData) async {
  try {
    if (parsedTrainingData != null) {
      final serializedData =
          parsedTrainingData.map((el) => el.toJson()).toList();
      final res = await handleBackendRequests(
          method: HTTP_METHOD.POST,
          endpoint: 'api/v1/trainings',
          body: {"trainings": serializedData});

      if (res['error'] != null) {
        throw res['error'];
      }

      final ids = res['content']['ids'];
      if (ids is List) {
        return ids.map((e) => int.tryParse(e.toString()) ?? 0).toList();
      } else {
        return [];
      }
    }
  } catch (error) {
    print('Error saving trainings to database $error');
    rethrow;
  }
  return [];
}

Future<List<ITrainingEntry>?> loadTrainingsRequest(
    String userId, int? limit, int? offset) async {
  Future<List<ITrainingEntry>?> handler() async {
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
        result.add(ITrainingEntry.fromJson(el));
      }

      print(result);
      return result;
    } catch (error) {
      print('Error loading trainings from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<ITrainingEntry>>(
      "${BACKEND_BASE_URL}api/v1/trainings/$userId?limit=$limit&offset=$offset",
      () async => await handler(),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return ITrainingEntry.fromJson(e);
          }).toList());
}

Future<void> authorizeStravaRequest(String userId) async {
  const clientId = '182205';
  final String redirectUri = '${BACKEND_BASE_URL}strava/auth?user_id=$userId';
  const scopes = 'activity:read,activity:read_all';
  try {
    final authUrl = 'https://www.strava.com/oauth/authorize?client_id=$clientId'
        '&response_type=code'
        '&redirect_uri=$redirectUri'
        '&scope=$scopes'
        '&approval_prompt=auto';
    print(authUrl);

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'finfit',
    );
    smartPrint("RESULT", result);
  } catch (error) {
    print('Error loading claimed rewards from database $error');
    rethrow;
  }
}
