import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';

Future<List<User>?> loadSendUsersRequest(String search, List<String>? ids,
    int? limit, int? offset, CancelToken cancelToken) async {
  Future<List<User>?> handler(
      String search, int? limit, int? offset, CancelToken cancelToken) async {
    final List<User> result = [];
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint:
              'api/v1/users?search=$search&ids=${Uri.encodeComponent(jsonEncode(ids))}&limit=$limit&offset=$offset',
          cancelToken: cancelToken);

      if (res['error'] != null) {
        throw res['error'];
      }

      final List content = res['content'];
      for (final el in content) {
        result.add(User.fromJson(el));
      }
      return result;
    } catch (error) {
      print('Error loading users from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<User>>(
    "${BACKEND_BASE_URL}api/v1/users?search=$search&limit=$limit&offset=$offset",
    () async => await handler(search, limit, offset, cancelToken),
    (list) => list.map((e) => e.toMap()).toList(),
    (data) => (data as List<dynamic>).map((e) {
      if (e is String) {
        // If e is a JSON string, decode it first
        final map = jsonDecode(e) as Map<String, dynamic>;
        return User.fromMap(map);
      } else if (e is Map<String, dynamic>) {
        // Already a map — good to go
        return User.fromMap(e);
      } else {
        throw Exception('Invalid user data type: ${e.runtimeType}');
      }
    }).toList(),
  );
}

Future<int?> resolveSendPointsRequest(
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
