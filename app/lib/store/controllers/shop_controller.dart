import 'dart:convert';

import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/shop/shop.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ShopController {
  final BehaviorSubject<int> _activeShopCategory = BehaviorSubject.seeded(0);
  Stream<int> get activeShopCategoryStream => _activeShopCategory.stream;
  int get activeShopCategory => _activeShopCategory.value;
  setActiveShopCategory(int category) {
    _activeShopCategory.add(category);
  }

  final BehaviorSubject<SortByData?> _sortBy = BehaviorSubject.seeded(null);
  Stream<SortByData?> get sortByStream => _sortBy.stream;
  SortByData? get sortBy => _sortBy.value;
  setSortByCategory(String category) {
    var currentSortBy = _sortBy.value;
    _sortBy.add(SortByData(
      category: category,
      sortingOrder: currentSortBy?.sortingOrder ?? SORTING_ORDER.ASCENDING,
    ));
  }

  setSortingOrder(SORTING_ORDER sortingOrder) {
    var currentSortBy = _sortBy.value;

    _sortBy.add(SortByData(
      category: currentSortBy?.category ?? '',
      sortingOrder: sortingOrder,
    ));
  }

  resetCurrentSortBy() {
    _sortBy.add(null);
  }

  final BehaviorSubject<SfRangeValues> _currentPriceRange =
      BehaviorSubject.seeded(SfRangeValues(0.0, 0.0));
  Stream<SfRangeValues> get currentPriceRangeStream =>
      _currentPriceRange.stream;
  SfRangeValues get currentPriceRange => _currentPriceRange.value;
  setCurrentPriceRange(SfRangeValues range) {
    _currentPriceRange.add(range);
  }

  final BehaviorSubject<SfRangeValues> _currentFinpointsCost =
      BehaviorSubject.seeded(SfRangeValues(0.0, 0.0));
  Stream<SfRangeValues> get currentFinpointsCostStream =>
      _currentFinpointsCost.stream;
  SfRangeValues get currentFinpointsCost => _currentFinpointsCost.value;
  setCurrentFinpointsCost(SfRangeValues range) {
    _currentFinpointsCost.add(range);
  }

  Stream<int> get numberOfActiveFiltersStream => Rx.combineLatest3(
      sortByStream,
      currentPriceRangeStream,
      currentFinpointsCostStream,
      (a, b, c) => getNumberOfActiveFilters(a, b, c, maxPriceRanges));

  final BehaviorSubject<IStoreMaxRanges> _maxPriceRanges =
      BehaviorSubject.seeded({});
  Stream<IStoreMaxRanges> get maxPriceRangesStream => _maxPriceRanges.stream;
  IStoreMaxRanges get maxPriceRanges => _maxPriceRanges.value;

  setMaxRanges(IStoreMaxRanges ranges, {bool saveToStorage = true}) {
    _maxPriceRanges.add(ranges);
    setCurrentPriceRange(SfRangeValues(0.0, ranges['max_price'] ?? 1000.0));
    setCurrentFinpointsCost(
        SfRangeValues(0.0, ranges['max_finpoints'] ?? 100000.0));
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
}

ShopController shopController = ShopController();
