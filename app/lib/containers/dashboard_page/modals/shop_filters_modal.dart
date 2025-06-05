import 'dart:async';

import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/buttons/radio_button.dart';
import 'package:excerbuys/components/shared/indicators/sliders/range_slider.dart';
import 'package:excerbuys/components/shared/positions/position.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';

import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/shop/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ShopFiltersModal extends StatefulWidget {
  const ShopFiltersModal({
    super.key,
  });

  @override
  State<ShopFiltersModal> createState() => _ShopFiltersModalState();
}

class _ShopFiltersModalState extends State<ShopFiltersModal> {
  StreamSubscription? _subscription;
  SORTING_ORDER? _sortingOrder = null;
  String? _sortByCategory = null;
  final ValueNotifier<SfRangeValues> _currentPriceRange =
      ValueNotifier<SfRangeValues>(SfRangeValues(0.0, 0.0));
  final ValueNotifier<SfRangeValues> _currentFinpointsCost =
      ValueNotifier<SfRangeValues>(SfRangeValues(0.0, 0.0));

  void resetFilters() {
    setState(() {
      _sortingOrder = null;
      _sortByCategory = null;
    });
    _currentPriceRange.value =
        SfRangeValues(0, shopController.maxPriceRanges['max_price'] ?? 1000);
    _currentFinpointsCost.value = SfRangeValues(
        0, shopController.maxPriceRanges['max_finpoints'] ?? 100000);

    shopController.resetCurrentSortBy();
    shopController.setCurrentPriceRange(_currentPriceRange.value);
    shopController.setCurrentFinpointsCost(_currentFinpointsCost.value);
  }

  void setFilters() {
    if (_sortByCategory != null &&
        _sortByCategory !=
            shopController.allShopFilters?.sortByData?.category) {
      shopController.setSortByCategory(_sortByCategory!);
    }
    if (_sortingOrder != null &&
        _sortingOrder !=
            shopController.allShopFilters?.sortByData?.sortingOrder) {
      shopController.setSortingOrder(_sortingOrder!);
    }
    if (_currentPriceRange.value !=
        shopController.allShopFilters?.currentPriceRange) {
      shopController.setCurrentPriceRange(_currentPriceRange.value);
    }
    if (_currentFinpointsCost.value !=
        shopController.allShopFilters?.currentFinpointsRange) {
      shopController.setCurrentFinpointsCost(_currentFinpointsCost.value);
    }
  }

  @override
  void initState() {
    super.initState();
    if (shopController.maxPriceRanges.isEmpty) {
      shopController.fetchMaxRanges();
    }

    _subscription = shopController.numberOfActiveFiltersStream.listen((event) {
      setState(() {
        _sortByCategory = shopController.allShopFilters?.sortByData?.category;
        _sortingOrder = shopController.allShopFilters?.sortByData?.sortingOrder;
      });
      if (shopController.allShopFilters != null) {
        _currentPriceRange.value =
            shopController.allShopFilters!.currentPriceRange;
        _currentFinpointsCost.value =
            shopController.allShopFilters!.currentFinpointsRange;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
      ),
      child: ModalContentWrapper(
          title: 'Shop filters',
          subtitle: 'Find what you need',
          onClose: () {
            closeModal(context);
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _currentPriceRange,
                          builder: (context, value, child) {
                            return StreamBuilder<IStoreMaxRanges>(
                                stream: shopController.maxPriceRangesStream,
                                builder: (context, snapshot) {
                                  final maxRange =
                                      snapshot.data?['max_price'] ?? 1000;
                                  return RangeSliderComponent(
                                    label: 'Price',
                                    range: {'min': 0, 'max': maxRange},
                                    values: value,
                                    suffix: 'PLN',
                                    stepSize: (maxRange / 30).roundToDouble(),
                                    onChanged: (SfRangeValues newValues) {
                                      _currentPriceRange.value = newValues;
                                    },
                                  );
                                });
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _currentFinpointsCost,
                          builder: (context, value, child) {
                            return StreamBuilder<IStoreMaxRanges>(
                                stream: shopController.maxPriceRangesStream,
                                builder: (context, snapshot) {
                                  final maxRange =
                                      snapshot.data?['max_finpoints'] ?? 100000;
                                  return RangeSliderComponent(
                                    label: 'Finpoints cost',
                                    range: {'min': 0, 'max': maxRange},
                                    values: value,
                                    stepSize: (maxRange / 100).roundToDouble(),
                                    suffix: 'finpoints',
                                    onChanged: (SfRangeValues newValues) {
                                      _currentFinpointsCost.value = newValues;
                                    },
                                  );
                                });
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Sort by',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                          children: List.generate(SHOP_FILTERS.length, (index) {
                        final el = SHOP_FILTERS[index];
                        return Position(
                          onPress: () {
                            setState(() {
                              _sortByCategory = el;
                              _sortingOrder ??= SORTING_ORDER.ASCENDING;
                            });
                          },
                          optionName: el,
                          isSelected: _sortByCategory == el,
                        );
                      }).toList()),
                      SizedBox(
                        height: 8,
                      ),
                      RadioButton(
                          value: SORTING_ORDER.ASCENDING,
                          activeValue: _sortingOrder,
                          onChanged: (SORTING_ORDER? val) {
                            setState(() {
                              _sortingOrder = val;
                            });
                          },
                          disabled: _sortByCategory == null,
                          label: 'Ascending'),
                      RadioButton(
                          value: SORTING_ORDER.DESCENDING,
                          activeValue: _sortingOrder,
                          onChanged: (SORTING_ORDER? val) {
                            setState(() {
                              _sortingOrder = val;
                            });
                          },
                          disabled: _sortByCategory == null,
                          label: 'Descending'),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: MainButton(
                          label: 'Reset',
                          backgroundColor:
                              colors.tertiaryContainer.withAlpha(80),
                          textColor: colors.primaryFixedDim,
                          onPressed: () {
                            resetFilters();
                            closeModal(context);
                          }),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: MainButton(
                          label: 'Confirm',
                          backgroundColor: colors.secondary,
                          textColor: colors.primary,
                          onPressed: () {
                            setFilters();
                            closeModal(context);
                          }),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
