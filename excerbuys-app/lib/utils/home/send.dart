import 'package:dio/dio.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';

Future<List<User>?> loadUsers(
    String search, int? limit, int? offset, CancelToken cancelToken) async {
  final List<User> result = [];
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/users?search=$search&limit=$limit&offset=$offset',
        cancelToken: cancelToken);

    if (res['error'] != null) {
      throw res['error'];
    }

    final List content = res['content'];
    for (final el in content) {
      result.add(User(
          id: el['id'],
          points: (el['points'] as int).toDouble(),
          username: el['username'],
          email: el['email'],
          image: el['image'],
          createdAt: DateTime.parse(el['created_at']).toLocal(),
          stepsUpdatedAt: DateTime.parse(el['steps_updated_at']).toLocal()));
    }
    return result;
  } catch (error) {
    print('Error loading users from database $error');
    rethrow;
  }
}

Future<User?> loadUserForId(String userId, CancelToken cancelToken) async {
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
        stepsUpdatedAt: DateTime.parse(el['steps_updated_at']).toLocal());

    return result;
  } catch (error) {
    print('Error loading user for id $userId $error');
    rethrow;
  }
}

Future<int?> resolveSendPoints(
    String userId, List<String> recipientsIds, int amount) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/users/send/$userId',
        body: {"recipients_ids": recipientsIds, "amount": amount});

    if (res['error'] != null) {
      throw res['error'];
    }

    if (res['content'] != null) {
      return parseInt(res['content']);
    }

    return null;
  } catch (error) {
    print('Error sending points $error');
    rethrow;
  }
}
