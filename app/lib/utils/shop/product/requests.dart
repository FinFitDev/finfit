import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';

Future<List<IProductEntry>?> loadHomeProductsRequest(String userId) async {
  // request handler to use instead of cache
  Future<List<IProductEntry>?> handler(String userId) async {
    final List<IProductEntry> result = [];
    try {
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/products/featured/$userId',
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
      "${BACKEND_BASE_URL}api/v1/products/featured/$userId",
      () async => await handler(userId),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IProductEntry.fromJson(e);
          }).toList());
}

Future<List<IProductEntry>?> loadProductsByFiltersRequest(ShopFilters? filters,
    int limit, int offset, CancelToken cancelToken) async {
  // request handler to use instead of cache
  Future<List<IProductEntry>?> handler(ShopFilters? filters, int limit,
      int offset, CancelToken cancelToken) async {
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint: generateUrlEndpointFromFilters(filters,
              limit: limit, offset: offset),
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

  return await Cache.fetch<List<IProductEntry>>(
      "${BACKEND_BASE_URL}${generateUrlEndpointFromFilters(filters, limit: limit, offset: offset)}",
      () async => await handler(filters, limit, offset, cancelToken),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IProductEntry.fromJson(e);
          }).toList());
}

Future<List<IProductEntry>?> loadProductsForProductOwnerRequest(
    String? id, int limit, int offset, CancelToken cancelToken) async {
  // request handler to use instead of cache
  Future<List<IProductEntry>?> handler(
      String? id, int limit, int offset, CancelToken cancelToken) async {
    try {
      final res = await handleBackendRequests(
          method: HTTP_METHOD.GET,
          endpoint: 'api/v1/products/$id?limit=$limit&offset=$offset',
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

  return await Cache.fetch<List<IProductEntry>>(
      "${BACKEND_BASE_URL}api/v1/products/$id?limit=$limit&offset=$offset",
      () async => await handler(id, limit, offset, cancelToken),
      (list) => list.map((e) => e.toJson()).toList(),
      (data) => (data as List<dynamic>).map((e) {
            return IProductEntry.fromJson(e);
          }).toList());
}
