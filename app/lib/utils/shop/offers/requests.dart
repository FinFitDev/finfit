import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<List<IOfferEntry>?> loadFeaturedOffersRequest() async {
  // request handler to use instead of cache
  Future<List<IOfferEntry>?> handler() async {
    final List<IOfferEntry> result = [];
    try {
      print('ANYHTINGIGNIGN');
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/offers/featured',
      );

      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'] as List<dynamic>;

      return content
          .map((item) => IOfferEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error loading featured offers from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<IOfferEntry>>(
      "${BACKEND_BASE_URL}api/v1/offers/featured",
      () async => await handler(),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IOfferEntry.fromJson(e);
          }).toList());
}

Future<List<IOfferEntry>?> loadAllOffersRequest(
    String search, int limit, int offset, CancelToken cancelToken) async {
  // request handler to use instead of cache
  Future<List<IOfferEntry>?> handler() async {
    final List<IOfferEntry> result = [];
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint: 'api/v1/offers?search=$search&limit=$limit&offset=$offset',
          cancelToken: cancelToken);
      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'] as List<dynamic>;

      return content
          .map((item) => IOfferEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error loading offers from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<IOfferEntry>>(
      "${BACKEND_BASE_URL}api/v1/offers?search=$search&limit=$limit&offset=$offset",
      () async => await handler(),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IOfferEntry.fromJson(e);
          }).toList());
}
