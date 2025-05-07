import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<List<IProductEntry>?> loadHomeProductsRequest(String userId) async {
  // request handler to use instead of cache
  Future<List<IProductEntry>?> handler(String userId) async {
    final List<IProductEntry> result = [];
    try {
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/products/$userId',
      );

      if (res['error'] != null) {
        throw res['error'];
      }

      final content = res['content'];
      // add all products together to the all prodcust list
      for (final el in List.from(content['affordable'])
        ..addAll(content['nearly_affordable'])) {
        result.add(IProductEntry.fromJson(el));
      }
      return result;
    } catch (error) {
      print('Error loading home products from database $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<IProductEntry>>(
      "${BACKEND_BASE_URL}api/v1/products/$userId",
      () async => await handler(userId),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IProductEntry.fromJson(e);
          }).toList());
}

Future<List<IProductEntry>?> loadProductsBySearchRequest(
    String search, int limit, int offset, CancelToken cancelToken) async {
  try {
    final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/products?search=$search&limit=$limit&offset=$offset',
        cancelToken: cancelToken);

    if (res['error'] != null) {
      throw res['error'];
    }

    final content = res['content'] as List<dynamic>;
    return content
        .map((item) => IProductEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (error) {
    print('Error loading search products from database $error');
    rethrow;
  }
}

Future<Map<String, double>> loadMaxPriceRanges() async {
  try {
    final res = await handleBackendRequests(
      method: HTTP_METHOD.GET,
      endpoint: 'api/v1/product_ranges',
    );

    if (res['error'] != null) {
      throw res['error'];
    }

    final Map<String, dynamic> content = res['content'];
    return Map.fromEntries(
        content.entries.map((e) => MapEntry(e.key, e.value.toDouble())));
  } catch (error) {
    print('Error loading product price ranges $error');
    rethrow;
  }
}
