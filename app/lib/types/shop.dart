import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SortByData {
  String category;
  SORTING_ORDER sortingOrder;

  SortByData({required this.category, required this.sortingOrder});
}

typedef IStoreMaxRanges = Map<String, double>;

class ShopFilters {
  String? search;
  int activeShopCategory;
  SortByData? sortByData;
  SfRangeValues currentPriceRange;
  SfRangeValues currentFinpointsRange;

  ShopFilters(
      {required this.activeShopCategory,
      this.search,
      this.sortByData,
      required this.currentFinpointsRange,
      required this.currentPriceRange});

  ShopFilters copyWith({
    Nullable<String>? search,
    Nullable<int>? activeShopCategory,
    Nullable<SortByData>? sortByData,
    Nullable<SfRangeValues>? currentPriceRange,
    Nullable<SfRangeValues>? currentFinpointsRange,
  }) {
    return ShopFilters(
        search: search == null
            ? this.search
            : search.isPresent
                ? search.value
                : null,
        activeShopCategory: activeShopCategory == null
            ? this.activeShopCategory
            : activeShopCategory.isPresent
                ? activeShopCategory.value!
                : throw ArgumentError('activeShopCategory cannot be null'),
        sortByData: sortByData == null
            ? this.sortByData
            : sortByData.isPresent
                ? sortByData.value
                : null,
        currentPriceRange: currentPriceRange?.value ?? this.currentPriceRange,
        currentFinpointsRange:
            currentFinpointsRange?.value ?? this.currentFinpointsRange);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopFilters &&
          runtimeType == other.runtimeType &&
          search == other.search &&
          activeShopCategory == other.activeShopCategory &&
          sortByData == other.sortByData &&
          currentPriceRange == other.currentPriceRange &&
          currentFinpointsRange == other.currentFinpointsRange;

  @override
  int get hashCode =>
      search.hashCode ^
      activeShopCategory.hashCode ^
      sortByData.hashCode ^
      currentPriceRange.hashCode ^
      currentFinpointsRange.hashCode;
}
