import 'dart:convert';
import 'dart:math';

import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/store/selectors/offers/shop.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/shop/product/filters.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

part 'mutations.dart';
part 'selectors.dart';
part 'effects.dart';

class ShopController {
  final BehaviorSubject<ShopFilters?> _allShopFilters = BehaviorSubject.seeded(
      ShopFilters(
          currentFinpointsRange: SfRangeValues(0, 0),
          currentPriceRange: SfRangeValues(0, 0),
          activeShopCategory: 0));
  Stream<ShopFilters?> get allShopFiltersStream => _allShopFilters.stream;
  ShopFilters? get allShopFilters => _allShopFilters.value;

  final BehaviorSubject<String?> _selectedProductOwner =
      BehaviorSubject.seeded(null);
  Stream<String?> get selectedProductOwnerStream =>
      _selectedProductOwner.stream;
  String? get selectedProductOwner => _selectedProductOwner.value;

  final BehaviorSubject<IStoreMaxRanges> _maxPriceRanges =
      BehaviorSubject.seeded({});
  Stream<IStoreMaxRanges> get maxPriceRangesStream => _maxPriceRanges.stream;
  IStoreMaxRanges get maxPriceRanges => _maxPriceRanges.value;

  final BehaviorSubject<List<String>> _availableCategories =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get availableCategoriesStream =>
      _availableCategories.stream;
  List<String> get availableCategories => _availableCategories.value;

  final BehaviorSubject<List<ICartItem>> _cartItems =
      BehaviorSubject.seeded([]);
  Stream<List<ICartItem>> get cartItemsStream => _cartItems.stream;
  List<ICartItem> get cartItems => _cartItems.value;
}

ShopController shopController = ShopController();
