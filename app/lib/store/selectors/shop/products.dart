import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';

IAllProductsData getAffordableProducts(
    IAllProductsData data, double? userBalance) {
  final filteredEntries = data.content.entries
      .where((entry) => entry.value.finpointsPrice <= (userBalance ?? 0))
      .toList();

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}

IAllProductsData getNearlyAffordableProducts(
    IAllProductsData data, double? userBalance) {
  final filteredEntries = data.content.entries
      .where((entry) =>
          entry.value.finpointsPrice < (userBalance ?? 0) - 5000 &&
          entry.value.finpointsPrice > (userBalance ?? 0))
      .toList();

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}

ContentWithLoading<List<IProductEntry>> getAffordableHomeProducts(
    IAllProductsData affordable, int limit) {
  final affordableProducts =
      affordable.content.values.toList().take(limit).toList();

  // Sort the products by totalTransactions field
  affordableProducts
      .sort((a, b) => b.totalTransactions.compareTo(a.totalTransactions));

  final newData = ContentWithLoading(content: affordableProducts);
  newData.isLoading = affordable.isLoading;

  return newData;
}

ContentWithLoading<List<IProductEntry>> getHomeNearlyAffordableProducts(
    IAllProductsData data, double? userBalance, int limit) {
  final notAffordable = getNearlyAffordableProducts(data, userBalance)
      .content
      .values
      .toList()
      .take(limit)
      .toList();

  // Sort the products by totalTransactions field
  notAffordable
      .sort((a, b) => b.totalTransactions.compareTo(a.totalTransactions));

  final newData = ContentWithLoading(content: notAffordable);
  newData.isLoading = data.isLoading;

  return newData;
}

IAllProductsData getProductsMatchingFilters(
    IAllProductsData data, ShopFilters? filters) {
  if (filters == null) {
    return IAllProductsData(content: {});
  }
  final filteredEntries = data.content.entries.where((entry) {
    final product = entry.value;

    final matchesSearch = product.name
        .toLowerCase()
        .contains((filters.search ?? '').toLowerCase());

    // Category filter 0 == 'ALL'

    final matchesCategory = (filters.activeShopCategory == 0) ||
        product.category ==
            shopController.availableCategories[filters.activeShopCategory - 1];

    // Price range filter
    final price = product.originalPrice;
    final matchesPrice = price >= filters.currentPriceRange.start &&
        price <= filters.currentPriceRange.end;

    // Finpoints range filter
    final finpoints = product.finpointsPrice;
    final matchesFinpoints = finpoints >= filters.currentFinpointsRange.start &&
        finpoints <= filters.currentFinpointsRange.end;

    return matchesSearch && matchesCategory && matchesPrice && matchesFinpoints;
  }).toList();

  // Sort (optional)
  if (filters.sortByData != null) {
    sortProductEntries(filteredEntries, filters.sortByData!);
  }

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}
