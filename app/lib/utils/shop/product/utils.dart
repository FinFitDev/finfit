import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/debug.dart';

String sortByCategoryParser(String displayText) {
  switch (displayText) {
    case 'Number of transactions':
      return 'total_transactions';
    case 'Date of issue':
      return 'created_at';
    case 'Price':
      return 'original_price';
    case 'Discount':
      return 'discount';
    case 'Cost in finpoints':
      return 'finpoints_price';
    default:
      return '';
  }
}

void sortProductEntries(
    List<MapEntry<String, IProductEntry>> entries, SortByData sortByData) {
  final sortBy = sortByCategoryParser(sortByData.category);
  final order = sortByData.sortingOrder;

  entries.sort((a, b) {
    dynamic aValue;
    dynamic bValue;

    switch (sortBy) {
      case 'created_at':
        aValue = a.value.createdAt;
        bValue = b.value.createdAt;
        break;
      case 'original_price':
        aValue = a.value.originalPrice;
        bValue = b.value.originalPrice;
        break;
      case 'total_transactions':
        aValue = a.value.totalTransactions;
        bValue = b.value.totalTransactions;
        break;
      case 'discount':
        aValue = a.value.discount;
        bValue = b.value.discount;
        break;
      case 'finpoints_price':
        aValue = a.value.finpointsPrice;
        bValue = b.value.finpointsPrice;
        break;
      default:
        aValue = 0;
        bValue = 0;
    }

    final cmp = Comparable.compare(aValue, bValue);
    return order == SORTING_ORDER.ASCENDING ? cmp : -cmp;
  });
}

String generateUrlEndpointFromFilters(ShopFilters? filters,
    {int limit = 20, int offset = 0}) {
  final params = <String, String>{};
  if (filters != null) {
    if (filters.search != null && filters.search!.isNotEmpty) {
      params['search'] = filters.search!;
    }

    // Category only if not "All" category
    if (filters.activeShopCategory != 0) {
      params['category'] =
          shopController.availableCategories[filters.activeShopCategory - 1];
    }

    // Price range (assume SfRangeValues has .start and .end)
    params['min_price'] = filters.currentPriceRange.start.round().toString();
    params['max_price'] = filters.currentPriceRange.end.round().toString();

    // Finpoints range
    params['min_finpoints'] =
        filters.currentFinpointsRange.start.round().toString();
    params['max_finpoints'] =
        filters.currentFinpointsRange.end.round().toString();

    // Sort info (optional)
    if (filters.sortByData != null) {
      params['sort_by'] = sortByCategoryParser(filters.sortByData!.category);
      params['order'] = filters.sortByData!.sortingOrder.name;
    }
  }

  // Always include pagination
  params['limit'] = limit.toString();
  params['offset'] = offset.toString();

  // Build query string safely
  final query = params.entries
      .map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');
  return 'api/v1/products?$query';
}

IProductVariantsSet buildVariantsSet(List<IProductVariant> variants) {
  final Map<String, Set<String>> optionsMap = {};
  final categories = optionsMap.keys.toList();

  for (final variant in variants) {
    variant.attributes.forEach((key, value) {
      optionsMap.putIfAbsent(key, () => <String>{});
      optionsMap[key]!.add(value);
    });
  }

  final Map<String, List<String>> groupedOptions = {
    for (var entry in optionsMap.entries) entry.key: entry.value.toList()
  };

  return IProductVariantsSet(
    categories: categories,
    options: groupedOptions,
    variants: variants,
  );
}
