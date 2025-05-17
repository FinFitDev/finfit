import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<List<IProductOwnerEntry>?> loadProductOwnersBySearchRequest(
    String search, int limit, int offset, CancelToken cancelToken) async {
  Future<List<IProductOwnerEntry>?> handler(
      String search, int limit, int offset, CancelToken cancelToken) async {
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint:
              'api/v1/product_owners?search=$search&limit=$limit&offset=$offset',
          cancelToken: cancelToken);

      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'] as List<dynamic>;
      return content
          .map((item) =>
              IProductOwnerEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error loading home product owners from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<IProductOwnerEntry>>(
      "${BACKEND_BASE_URL}api/v1/product_owners?search=$search&limit=$limit&offset=$offset",
      () async => await handler(search, limit, offset, cancelToken),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IProductOwnerEntry.fromJson(e);
          }).toList());
}
