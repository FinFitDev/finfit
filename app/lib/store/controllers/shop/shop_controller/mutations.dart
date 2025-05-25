part of 'shop_controller.dart';

extension ShopControllerMutations on ShopController {
  resetShopFilters() {
    resetCurrentSortBy();
    setSearchValue(null);
  }

  setAllShopFilters(ShopFilters? filters) {
    _allShopFilters.add(filters);
  }

  setActiveShopCategory(int category) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final newFilters = currentFilters.copyWith(
          activeShopCategory: Nullable.present(category));
      setAllShopFilters(newFilters);
    }
  }

  setSortByCategory(String category) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final currentSortBy = allShopFilters!.sortByData;

      final newFilters = currentFilters.copyWith(
          sortByData: Nullable.present(SortByData(
        category: category,
        sortingOrder: currentSortBy?.sortingOrder ?? SORTING_ORDER.ASCENDING,
      )));
      setAllShopFilters(newFilters);
    }
  }

  setSortingOrder(SORTING_ORDER sortingOrder) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final currentSortBy = allShopFilters!.sortByData;

      final newFilters = currentFilters.copyWith(
          sortByData: Nullable.present(SortByData(
        category: currentSortBy?.category ?? '',
        sortingOrder: sortingOrder,
      )));
      setAllShopFilters(newFilters);
    }
  }

  resetCurrentSortBy() {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final newFilters =
          currentFilters.copyWith(sortByData: Nullable.present(null));
      setAllShopFilters(newFilters);
    }
  }

  setCurrentPriceRange(SfRangeValues range) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final newFilters =
          currentFilters.copyWith(currentPriceRange: Nullable.present(range));
      setAllShopFilters(newFilters);
    }
  }

  setCurrentFinpointsCost(SfRangeValues range) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      final newFilters = currentFilters.copyWith(
          currentFinpointsRange: Nullable.present(range));
      setAllShopFilters(newFilters);
    }
  }

  setSearchValue(String? value) {
    final currentFilters = allShopFilters;
    if (currentFilters != null) {
      if (value?.trim() != currentFilters.search) {
        productOwnersController.handleOnSearch(value?.trim() ?? '');
      }
      final newFilters =
          currentFilters.copyWith(search: Nullable.present(value));
      setAllShopFilters(newFilters);
    }
  }

  setSelectedProductOwner(String? ownerId) {
    _selectedProductOwner.add(ownerId);
  }

  setMaxRanges(IStoreMaxRanges ranges) {
    _maxPriceRanges.add(ranges);
    setCurrentPriceRange(SfRangeValues(0.0, ranges['max_price'] ?? 0.0));
    setCurrentFinpointsCost(SfRangeValues(0.0, ranges['max_finpoints'] ?? 0.0));
  }

  setAvailableCategories(List<String> categories) {
    _availableCategories.add(categories);
  }
}
