import 'dart:convert';

import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/utils/activity/constants.dart';
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

Future<String> authorizeStravaRequest(String userId) async {
  final String redirectUri = '${BACKEND_BASE_URL}strava/auth?user_id=$userId';
  try {
    final authUrl =
        'https://www.strava.com/oauth/authorize?client_id=$STRAVA_CLIENT_ID'
        '&response_type=code'
        '&redirect_uri=$redirectUri'
        '&scope=$STRAVA_SCOPES'
        '&approval_prompt=auto';

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'finfit',
    );
    print(result);
    return result;
  } catch (error) {
    print('Error authorizing strava $error');
    rethrow;
  }
}

Future<bool> updateStravaEnabledRequest(String userId, bool value) async {
  try {
    final res = await handleBackendRequests(
      method: HTTP_METHOD.PUT,
      endpoint: 'api/v1/users/strava/enabled/$userId?enabled=$value',
    );

    print(res);

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'];
  } catch (error) {
    print('Error updating strava permissions $error');
    rethrow;
  }
}
