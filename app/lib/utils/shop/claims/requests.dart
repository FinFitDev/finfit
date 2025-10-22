import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/shop/reward.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<String?> claimDiscountCodeRequest(String offerId, String userId) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.POST,
        endpoint: 'api/v1/offers/claim/$offerId',
        body: {
          "user_id": userId,
        });

    if (res['error'] != null) {
      throw res['error'];
    }

    final content = res['content'];

    return content;
  } catch (error) {
    print('Error claimimng discount in database $error');
    rethrow;
  }
}

Future<List<IClaimEntry>?> loadAllClaimsRequest(
    String userId, CancelToken cancelToken) async {
  // request handler to use instead of cache
  Future<List<IClaimEntry>?> handler() async {
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint: 'api/v1/claims/$userId',
          cancelToken: cancelToken);

      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'] as List<dynamic>;

      return content
          .map((item) => IClaimEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error loading claimed rewards from database $error');
      rethrow;
    }
  }

  return handler();

  // return await Cache.fetch<List<IClaimEntry>>(
  //     "${BACKEND_BASE_URL}api/v1/claims/$userId",
  //     () async => await handler(),
  //     (list) => list.map((e) => e.toJson()).toList(),
  //     (data) => (data as List<dynamic>).map((e) {
  //           return IClaimEntry.fromJson(e);
  //         }).toList());
}
