import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';

ContentWithLoading<Map<String, IProductEntry>> getAffordableProducts(
    ContentWithLoading<Map<String, IProductEntry>> data) {
  final filteredEntries = data.content.entries
      .where((entry) => entry.value.isAffordable == true)
      .toList();

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}

ContentWithLoading<Map<String, IProductEntry>> getNonAffordableProducts(
    ContentWithLoading<Map<String, IProductEntry>> data) {
  final filteredEntries = data.content.entries
      .where((entry) => entry.value.isAffordable != true)
      .toList();

  final sortedContent = Map<String, IProductEntry>.fromEntries(filteredEntries);

  return data.copyWith(content: sortedContent);
}

ContentWithLoading<List<IProductEntry>> getAffordableHomeProducts(
    ContentWithLoading<Map<String, IProductEntry>> affordable, int limit) {
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
    ContentWithLoading<Map<String, IProductEntry>> data, int limit) {
  final notAffordable = getNonAffordableProducts(data)
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
