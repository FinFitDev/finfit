import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:uuid/v4.dart';

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

class IProductVariantsSet {
  final List<String> categories;
  final Map<String, List<String>> options;
  final List<IProductVariant> variants;

  IProductVariantsSet({
    required this.categories,
    required this.options,
    required this.variants,
  });

  IProductVariantsSet copyWith({
    List<String>? categories,
    Map<String, List<String>>? options,
    List<IProductVariant>? variants,
  }) {
    return IProductVariantsSet(
      categories: categories ?? this.categories,
      options: options ?? this.options,
      variants: variants ?? this.variants,
    );
  }

  IProductVariant? findVariant(Map<String, String> selectedAttributes) {
    return variants
        .where(
          (variant) => _attributesMatch(variant.attributes, selectedAttributes),
        )
        .firstOrNull;
  }

  String? findVariantId(Map<String, String> selectedAttributes) {
    final variant = findVariant(selectedAttributes);
    return variant?.id;
  }

  IProductVariant? findVariantById(String variantId) {
    return variants.where((variant) => variant.id == variantId).firstOrNull;
  }

  bool _attributesMatch(
      Map<String, String> variantAttrs, Map<String, String> selectedAttrs) {
    for (final key in selectedAttrs.keys) {
      if (variantAttrs[key] != selectedAttrs[key]) {
        return false;
      }
    }
    return true;
  }

  List<IProductVariant>? findVariants(Map<String, String> selectedAttributes) {
    return variants
        .where(
          (variant) =>
              _anyAttributeMatches(variant.attributes, selectedAttributes),
        )
        .toList();
  }

  bool _anyAttributeMatches(
      Map<String, String> variantAttrs, Map<String, String> selectedAttr) {
    for (final key in selectedAttr.keys) {
      if (variantAttrs[key] == selectedAttr[key]) {
        return true;
      }
    }
    return false;
  }

  Map<String, List<String>> getUnavailableAttributes(
      Map<String, String> selectedAttributes) {
    final Map<String, Set<String>> unavailableAttributesMap = {};

    // Case 1: Something is selected
    if (selectedAttributes.isNotEmpty) {
      for (final variant in variants) {
        if (!variant.available &&
            _anyAttributeMatches(variant.attributes, selectedAttributes)) {
          // Keep only attributes not already selected
          for (final entry in variant.attributes.entries) {
            if (!selectedAttributes.values.contains(entry.value)) {
              unavailableAttributesMap
                  .putIfAbsent(entry.key, () => <String>{})
                  .add(entry.value);
            }
          }
        }
      }
    }
    // Case 2: Nothing is selected → find attribute values that make all variants with them unavailable
    else {
      final Map<String, Map<String, List<IProductVariant>>> grouped = {};

      // Group all variants by attribute key and value
      for (final variant in variants) {
        variant.attributes.forEach((key, value) {
          grouped.putIfAbsent(key, () => {});
          grouped[key]!.putIfAbsent(value, () => []);
          grouped[key]![value]!.add(variant);
        });
      }

      // For each group, if all variants for a value are unavailable, mark it as unavailable
      grouped.forEach((key, valueMap) {
        valueMap.forEach((value, varList) {
          if (varList.every((v) => !v.available)) {
            unavailableAttributesMap
                .putIfAbsent(key, () => <String>{})
                .add(value);
          }
        });
      });
    }

    return {
      for (final entry in unavailableAttributesMap.entries)
        entry.key: entry.value.toList()
    };
  }
}

class ICartItem implements HasQuantity {
  final String? uuid;
  final IProductEntry product;
  final IProductVariant? variant;
  int quantity;
  final bool? notEligible;

  ICartItem({
    required this.product,
    this.variant,
    this.quantity = 1,
    this.notEligible,
    String? uuid,
  }) : uuid = uuid ?? UuidV4().generate();

  ICartItem copyWith(
      {IProductEntry? product,
      IProductVariant? variant,
      int? quantity,
      bool? notEligible}) {
    return ICartItem(
        product: product ?? this.product,
        variant: variant ?? this.variant,
        quantity: quantity ?? this.quantity,
        notEligible: notEligible ?? this.notEligible,
        uuid: this.uuid);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ICartItem &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  bool isEqualParamsSet(ICartItem other) {
    return product.uuid == other.product.uuid &&
        variant?.id == other.variant?.id;
  }

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
