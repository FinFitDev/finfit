import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/types/shop/product.dart';
import 'package:excerbuys/types/shop/shop.dart';
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

Map<String, int> minimizePrice(int maxFinpointsBalance, List<ICartItem> items) {
  final int n = items.length;
  // dp[i] maps balanceUsed => minTotalCost
  List<Map<int, double>> dp = List.generate(n + 1, (_) => {});
  // quantities for each item
  List<Map<int, int>> path = List.generate(n + 1, (_) => {});

  dp[0][0] = 0.0;

  for (int i = 0; i < n; i++) {
    final item = items[i];
    final current = dp[i];

    for (final entry in current.entries) {
      final int usedFinpointsBalance = entry.key;
      final double currentPrice = entry.value;

      // Try choosing q eligible units from 0 to quantity
      for (int q = 0; q <= item.quantity; q++) {
        final int addedFinpointsCost = q * item.product.finpointsPrice.round();
        final int newFinpointsBalance =
            usedFinpointsBalance + addedFinpointsCost;

        if (newFinpointsBalance > maxFinpointsBalance) break;

        final double totalPrice = q * item.getPrice(isEligible: true) +
            (item.quantity - q) * item.getPrice(isEligible: false);

        final double newTotal = currentPrice + totalPrice;

        if (!dp[i + 1].containsKey(newFinpointsBalance) ||
            newTotal < dp[i + 1][newFinpointsBalance]!) {
          dp[i + 1][newFinpointsBalance] = newTotal;
          path[i + 1][newFinpointsBalance] = q;
        }
      }
    }
  }
  // Find best final balance (lowest total cost)
  double minCost = double.infinity;
  int bestBalance = 0;
  for (final entry in dp[n].entries) {
    if (entry.value < minCost) {
      minCost = entry.value;
      bestBalance = entry.key;
    }
  }

// Backtrack to find how many units to make eligible
  Map<String, int> eligibleUnits = {};
  int b = bestBalance;
  for (int i = n; i > 0; i--) {
    final q = path[i][b]!;
    eligibleUnits[items[i - 1].uuid!] = q;
    b -= q * items[i - 1].product.finpointsPrice.round();
  }

// Remove entries with 0 quantity
  eligibleUnits.removeWhere((key, value) => value == 0);

  return eligibleUnits; // Map<Item uuid, quantity to qualify>
}

void convertNotEligibleItemsToEligible({
  required List<ICartItem> updatedItems,
  required Map<String, int> itemMapToQualify,
  required List<ICartItem> notEligibleItems,
}) {
  for (final entry in itemMapToQualify.entries) {
    final itemUUID = entry.key;
    final qtyToMakeEligible = entry.value;

    final foundItem =
        notEligibleItems.where((el) => el.uuid == itemUUID).firstOrNull;
    if (foundItem == null || qtyToMakeEligible == 0) continue;

    // 1. Remove or reduce not-eligible item
    final foundIndex = updatedItems.indexWhere((el) => el.uuid == itemUUID);
    if (foundIndex != -1) {
      final reducedQty = foundItem.quantity - qtyToMakeEligible;
      if (reducedQty > 0) {
        updatedItems[foundIndex] = foundItem.copyWith(quantity: reducedQty);
      } else {
        updatedItems.removeAt(foundIndex);
      }
    }

    // 2. Add or update eligible version
    final existingEligible = updatedItems
        .where((el) => el.notEligible != true && el.isEqualParamsSet(foundItem))
        .firstOrNull;

    if (existingEligible != null) {
      final ei = updatedItems.indexOf(existingEligible);
      updatedItems[ei] = existingEligible.copyWith(
        quantity: existingEligible.quantity + qtyToMakeEligible,
      );
    } else {
      updatedItems.add(foundItem.copyWith(
        quantity: qtyToMakeEligible,
        notEligible: false,
      ));
    }
  }
}
