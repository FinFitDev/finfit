import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/shop/shop.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ShopController {
  final BehaviorSubject<ShopFilters?> _allShopFilters = BehaviorSubject.seeded(
      ShopFilters(
          currentFinpointsRange: SfRangeValues(0, 0),
          currentPriceRange: SfRangeValues(0, 0),
          activeShopCategory: 0));
  Stream<ShopFilters?> get allShopFiltersStream => _allShopFilters.stream;
  ShopFilters? get allShopFilters => _allShopFilters.value;
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

  Stream<int> get numberOfActiveFiltersStream => allShopFiltersStream
      .map((a) => getNumberOfActiveFilters(a, maxPriceRanges));

  Stream<String?> get searchValueStream =>
      allShopFiltersStream.map((data) => data?.search ?? '');

  Stream<int> get activeShopCategoryStream =>
      allShopFiltersStream.map((data) => data?.activeShopCategory ?? 0);

  restoreFilterOptionsFromStorage() {
    restoreMaxRangesStateFromStorage();
    restoreAvailableCategoriesFromStorage();
  }

  final BehaviorSubject<IStoreMaxRanges> _maxPriceRanges =
      BehaviorSubject.seeded({});
  Stream<IStoreMaxRanges> get maxPriceRangesStream => _maxPriceRanges.stream;
  IStoreMaxRanges get maxPriceRanges => _maxPriceRanges.value;

  setMaxRanges(IStoreMaxRanges ranges, {bool saveToStorage = true}) {
    _maxPriceRanges.add(ranges);
    setCurrentPriceRange(SfRangeValues(0.0, ranges['max_price'] ?? 0.0));
    setCurrentFinpointsCost(SfRangeValues(0.0, ranges['max_finpoints'] ?? 0.0));
    if (saveToStorage) {
      storageController.saveStateLocal(
          MAX_PRICE_RANGES_KEY, jsonEncode(ranges));
    }
  }

  restoreMaxRangesStateFromStorage() async {
    try {
      final String? maxRangesSaved =
          await storageController.loadStateLocal(MAX_PRICE_RANGES_KEY);

      if (maxRangesSaved != null && maxRangesSaved.isNotEmpty) {
        Map<String, dynamic> decoded =
            Map<String, dynamic>.from(jsonDecode(maxRangesSaved));
        Map<String, double> parsed = Map.fromEntries(
          decoded.entries.map(
            (e) => MapEntry(e.key, e.value.toDouble()),
          ),
        );
        // don't save to storage again
        setMaxRanges(parsed, saveToStorage: false);
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  Future<void> fetchMaxRanges() async {
    try {
      final IStoreMaxRanges fetchedRanges = await loadMaxPriceRanges();
      if (fetchedRanges.isEmpty) {
        throw 'No ranges found';
      }
      setMaxRanges(fetchedRanges);
    } catch (error) {
      print(error);
    }
  }

  final BehaviorSubject<List<String>> _availableCategories =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get availableCategoriesStream =>
      _availableCategories.stream;
  List<String> get availableCategories => _availableCategories.value;

  setAvailableCategories(List<String> categories, {bool saveToStorage = true}) {
    _availableCategories.add(categories);

    if (saveToStorage) {
      storageController.saveStateLocal(
          AVAILABLE_SHOP_CATEGORIES_KEY, jsonEncode(categories));
    }
  }

  restoreAvailableCategoriesFromStorage() async {
    try {
      final String? availableCategoriesSaved =
          await storageController.loadStateLocal(AVAILABLE_SHOP_CATEGORIES_KEY);

      if (availableCategoriesSaved != null &&
          availableCategoriesSaved.isNotEmpty) {
        // don't save to storage again
        setAvailableCategories(
            (jsonDecode(availableCategoriesSaved) as List<dynamic>)
                .map((el) => el.toString())
                .toList(),
            saveToStorage: false);
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  Future<void> fetchAvailableCategories() async {
    try {
      final List<String> fetchedCategories = await loadAvailableCategories();
      if (fetchedCategories.isEmpty) {
        throw 'No categories found';
      }
      setAvailableCategories(fetchedCategories);
    } catch (error) {
      print(error);
    }
  }

  Stream<ShopFilters?> shopPageUpdateTrigger() {
    return Rx.combineLatest4(
      productOwnersController.allProductOwnersStream,
      productsController.allProductsStream,
      productsController.lazyLoadOffsetStream,
      allShopFiltersStream.distinct(),
      (ContentWithLoading<Map<String, IProductOwnerEntry>> owners,
          IAllProductsData products,
          ContentWithLoading<int> offset,
          ShopFilters? filters) {
        return filters;
      },
    );
  }
}

ShopController shopController = ShopController();
