import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/debug.dart';

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

IAllProductsData getProductsMatchingSearch(
    IAllProductsData data, String? search) {
  final filteredEntries = data.content.entries
      .where((entry) =>
          entry.value.name.toLowerCase().contains((search ?? '').toLowerCase()))
      .toList();

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}
