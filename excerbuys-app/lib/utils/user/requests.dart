import 'package:dio/dio.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';

Future<bool> updatePointsScoreWithUpdateTimestampRequest(
    String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/points/$userId',
        body: {
          "points": points.toString(),
          "steps_updated_at": DateTime.now().toString()
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'] == 'UPDATE';
  } catch (error) {
    print(error);
    return false;
  }
}

Future<bool> updatePointsScoreRequest(String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/points/$userId',
        body: {
          "points": points.toString(),
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'] == 'UPDATE';
  } catch (error) {
    print(error);
    return false;
  }
}

Future<bool> updateUserImageRequest(String userId, String image) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/image/$userId',
        body: {
          "image": image,
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    return res['content'] == 'UPDATE';
  } catch (error) {
    print(error);
    return false;
  }
}

Future<User?> fetchUserByIdRequest(
    String userId, CancelToken? cancelToken) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/users/$userId',
        cancelToken: cancelToken);

    if (res['error'] != null) {
      throw res['error'];
    }

    final dynamic el = res['content'];

    final User result = User(
        id: el['id'],
        points: parseInt(el['points'] as int).toDouble(),
        username: el['username'],
        email: el['email'],
        image: el['image'],
        createdAt: DateTime.parse(el['created_at']).toLocal(),
        stepsUpdatedAt: DateTime.parse(el['steps_updated_at']).toLocal(),
        verified: el['verified']);

    return result;
  } catch (error) {
    print('Error loading user for id $userId $error');
    rethrow;
  }
}

Future<bool?> fetchUserByEmailRequest(String email) async {
  final res = await handleBackendRequests(
    method: HTTP_METHOD.GET,
    endpoint: 'auth/user?email=$email',
  );

  if (res['error'] != null) {
    throw res['error'];
  }

  return res['content'];
}
