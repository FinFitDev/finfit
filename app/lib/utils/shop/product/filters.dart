import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<Map<String, double>?> loadMaxPriceRanges() async {
  Future<Map<String, double>?> handler() async {
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

  return await Cache.fetch<Map<String, double>>(
      "${BACKEND_BASE_URL}api/v1/product_ranges",
      handler,
      (map) => map,
      (data) => (data as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ),
      validFor: 24 * ONE_HOUR_CACHE_VALIDITY_PERIOD);
}

Future<List<String>?> loadAvailableCategories() async {
  Future<List<String>> handler() async {
    try {
      final res = await handleBackendRequests(
        method: HTTP_METHOD.GET,
        endpoint: 'api/v1/product_categories',
      );

      if (res['error'] != null) {
        throw res['error'];
      }
      final List<dynamic> content = res['content'];
      final List<String> categories =
          content.map((el) => el['category'] as String).toList();

      return categories;
    } catch (error) {
      print('Error loading product categories $error');
      rethrow;
    }
  }

  return await Cache.fetch<List<String>>(
      "${BACKEND_BASE_URL}api/v1/product_categories",
      handler,
      (list) => list,
      (data) => (data as List<dynamic>).map((el) => el.toString()).toList(),
      validFor: 24 * ONE_HOUR_CACHE_VALIDITY_PERIOD);
}
