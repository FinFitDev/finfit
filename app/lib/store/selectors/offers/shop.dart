import 'dart:math';

import 'package:excerbuys/types/shop/shop.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

int getNumberOfActiveFilters(ShopFilters? filters, IStoreMaxRanges maxRanges) {
  var sum = 0;
  if (maxRanges.isEmpty) {
    return sum;
  }
  if (filters?.sortByData != null) {
    sum++;
  }
  if (filters?.currentPriceRange.start != 0 ||
      filters?.currentPriceRange.end != maxRanges['max_price']) {
    sum++;
  }
  if (filters?.currentFinpointsRange.start != 0 ||
      filters?.currentFinpointsRange.end != maxRanges['max_finpoints']) {
    sum++;
  }
  return sum;
}

ShopFilters getShopFiltersValues(
  String? search,
  SfRangeValues finpointsRange,
  SfRangeValues priceRange,
  SortByData? sortBy,
  int activeCategory,
) {
  final filters = ShopFilters(
      activeShopCategory: activeCategory,
      currentFinpointsRange: finpointsRange,
      currentPriceRange: priceRange,
      search: search,
      sortByData: sortBy);

  return filters;
}
