import 'dart:math';

import 'package:excerbuys/types/shop.dart';
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

int countTotalCartFinpointsCost(List<ICartItem> cartItems) {
  return cartItems.fold(
      0,
      (count, item) =>
          count +
          (item.notEligible == true
              ? 0
              : (item.product.finpointsPrice.round() * item.quantity)));
}

double countTotalCartPrice(List<ICartItem> cartItems) {
  return cartItems.fold(0, (count, item) {
    return count + (item.getPrice() * item.quantity);
  });
}

double? getUserBalanceMinusCartCost(double? userBalance, int cartCost) {
  return max(0, (userBalance ?? 0) - cartCost);
}

double getTotalDiscountSavings(List<ICartItem> cartItems) {
  return cartItems.fold(
      0,
      (count, item) =>
          count +
          ((item.getPrice(isEligible: false) - item.getPrice()) *
              item.quantity));
}
