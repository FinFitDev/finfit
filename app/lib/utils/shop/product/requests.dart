import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

Future<List<IProductEntry>?> loadHomeProductsRequest(String userId) async {
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
