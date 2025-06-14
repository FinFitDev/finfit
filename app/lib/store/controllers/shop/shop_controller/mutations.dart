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

  setCartItems(List<ICartItem> items) {
    _cartItems.add(items);
    saveCartStateToStorage();
  }

  addCartItem(ICartItem item) {
    final currentItems = cartItems;
    if (!currentItems.any((i) => i.isEqualParamsSet(item))) {
      _cartItems.add([...currentItems, item]);
      saveCartStateToStorage();
    }
  }

  void removeCartItem(String itemId) {
    final currentItems = cartItems;
    final itemIndex = currentItems.indexWhere((i) => i.uuid == itemId);
    if (itemIndex == -1) return;

    final itemToRemove = currentItems[itemIndex];

    userBalanceMinusCartCost.first.then((balanceLeft) {
      final updatedItems = List<ICartItem>.from(currentItems)
        ..removeAt(itemIndex);

      // Only refund balance if item was eligible
      if (itemToRemove.notEligible != true) {
        final refundAmount =
            itemToRemove.quantity * itemToRemove.product.finpointsPrice;
        final simulatedBalance = (balanceLeft ?? 0) + refundAmount;

        final notEligibleItems =
            currentItems.where((el) => el.notEligible == true).toList();

        final Map<String, int> itemMapToQualify =
            minimizePrice(simulatedBalance.round(), notEligibleItems);

        convertNotEligibleItemsToEligible(
          updatedItems: updatedItems,
          itemMapToQualify: itemMapToQualify,
          notEligibleItems: notEligibleItems,
        );
      }

      _cartItems.add(updatedItems);
      saveCartStateToStorage();
    });
  }

  increaseProductQuantity(String cartItemId) {
    final currentItems = cartItems;
    final itemIndex = currentItems.indexWhere((i) => i.uuid == cartItemId);
    if (itemIndex != -1) {
      final updatedItems = List<ICartItem>.from(currentItems);
      final currentItem = currentItems[itemIndex];

      userBalanceMinusCartCost.first.then((balanceLeft) {
        if ((balanceLeft ?? 0) < currentItem.product.finpointsPrice &&
            currentItem.notEligible != true) {
          final sameParamsNotEligible = currentItems
              .where((ICartItem el) =>
                  el.notEligible == true && el.isEqualParamsSet(currentItem))
              .firstOrNull;
          // if we increase quantity of eligible product but product not eligible
          // with the same parameters is already added we want to increase the quantity of that product
          if (sameParamsNotEligible != null) {
            final updatedItem = sameParamsNotEligible.copyWith(
                quantity: sameParamsNotEligible.quantity + 1);
            final index = updatedItems.indexOf(sameParamsNotEligible);
            updatedItems[index] = updatedItem;
          } else {
            updatedItems.add(ICartItem(
                product: currentItem.product,
                variant: currentItem.variant,
                quantity: 1,
                notEligible: true));
          }
        } else {
          final updatedItem = currentItems[itemIndex]
              .copyWith(quantity: currentItems[itemIndex].quantity + 1);
          updatedItems[itemIndex] = updatedItem;
        }
        _cartItems.add(updatedItems);
        saveCartStateToStorage();
      });
    }
  }

  void decreaseProductQuantity(String cartItemId) {
    final currentItems = cartItems;
    final itemIndex = currentItems.indexWhere((i) => i.uuid == cartItemId);
    if (itemIndex == -1) return;

    userBalanceMinusCartCost.first.then((balanceLeft) {
      final currentItem = currentItems[itemIndex];
      final updatedItems = List<ICartItem>.from(currentItems);

      // Decrease quantity (or clamp at 1)
      final updatedItem = currentItem.copyWith(
        quantity: max(1, currentItem.quantity - 1),
      );
      updatedItems[itemIndex] = updatedItem;

      // we only optimize if item is eligible
      if (currentItem.notEligible != true) {
        // Simulated balance after "refunding" one item's cost
        final simulatedBalance =
            (balanceLeft ?? 0) + currentItem.product.finpointsPrice;

        // Find not eligible items
        final notEligibleItems =
            currentItems.where((el) => el.notEligible == true).toList();

        // Run optimizer to decide which notEligible items to make eligible
        final Map<String, int> itemMapToQualify =
            minimizePrice(simulatedBalance.round(), notEligibleItems);

        convertNotEligibleItemsToEligible(
            updatedItems: updatedItems,
            itemMapToQualify: itemMapToQualify,
            notEligibleItems: notEligibleItems);
      }

      _cartItems.add(updatedItems);
      saveCartStateToStorage();
    });
  }
}
