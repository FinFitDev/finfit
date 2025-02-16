import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<bool> updatePointsScoreWithUpdateTimestamp(
    String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/$userId',
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

Future<bool> updatePointsScore(String userId, int points) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/$userId',
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
