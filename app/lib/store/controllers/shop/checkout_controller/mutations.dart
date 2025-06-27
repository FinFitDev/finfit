part of 'checkout_controller.dart';

extension CheckoutControllerMutations on CheckoutController {
  setCartItems(List<ICartItem> items) {
    _cartItems.add(items);
    saveCartStateToStorage();
  }

  addCartItem(ICartItem item) {
    final currentItems = cartItems;
    if (!currentItems.any((i) => i.isEqualParamsSet(item))) {
      _cartItems.add([...currentItems, item]);
      saveCartStateToStorage();
      removeOrderByCartItemsOwnerId(item);
    }
  }

  void removeCartItem(String itemId) {
    final currentItems = cartItems;
    final itemIndex = currentItems.indexWhere((i) => i.uuid == itemId);
    if (itemIndex == -1) return;

    removeOrderByCartItemsId(itemId);

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
      removeOrderByCartItemsId(cartItemId);

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

    removeOrderByCartItemsId(cartItemId);

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

  setUserOrderData(IUserOrderData? data) {
    _userOrderData.add(data);
    saveUserOrderDataToStorage();
  }

  setOrders(List<IOrder> orders, {bool saveToStorage = true}) {
    _orders.add(orders);
    if (saveToStorage) saveOrdersDataToStorage();
  }

  addOrder(IOrder order) {
    final currentOrders = orders;
    if (currentOrders.contains(order)) {
      return;
    }
    setOrders([...currentOrders, order]);
  }

  void removeOrderByCartItemsOwnerId(ICartItem cartItem) {
    final currentOrders = orders;

    final orderIndex = currentOrders.indexWhere((o) {
      // get first one only because all cart items in order should have the same owner
      final cartItemId = o.cartItemsIds.isNotEmpty ? o.cartItemsIds[0] : null;
      if (cartItemId == null) return false;

      final matchedCartItem = cartItems
          .where(
            (item) => item.uuid == cartItemId,
          )
          .firstOrNull;

      return matchedCartItem?.product.owner.uuid == cartItem.product.owner.uuid;
    });

    if (orderIndex != -1) {
      removeOrder(currentOrders[orderIndex].uuid);
    }
  }

  removeOrderByCartItemsId(String cartItemId) {
    final currentOrders = orders;
    final orderIndex =
        currentOrders.indexWhere((o) => o.containsItem(cartItemId));
    if (orderIndex != -1) {
      removeOrder(currentOrders[orderIndex].uuid);
    }
  }

  removeOrder(String orderId) {
    final currentOrders = orders;
    final orderIndex = currentOrders.indexWhere((o) => o.uuid == orderId);
    if (orderIndex != -1) {
      final updatedOrders = List<IOrder>.from(currentOrders)
        ..removeAt(orderIndex);
      setOrders(updatedOrders);
    }
  }

  changeOrderDeliveryDetails(
      String orderId, IDeliveryDetails? deliveryDetails) {
    final currentOrders = orders;
    final orderIndex = currentOrders.indexWhere((o) => o.uuid == orderId);
    if (orderIndex != -1) {
      final updatedOrder = currentOrders[orderIndex].copyWith(
        deliveryDetails: deliveryDetails,
      );
      final updatedOrders = List<IOrder>.from(currentOrders)
        ..[orderIndex] = updatedOrder;
      setOrders(updatedOrders);
    }
  }

  changeOrderUserData(String orderId, IUserOrderData? userData) {
    final currentOrders = orders;
    final orderIndex = currentOrders.indexWhere((o) => o.uuid == orderId);
    if (orderIndex != -1) {
      final updatedOrder = currentOrders[orderIndex].copyWith(
        userData: userData,
      );
      final updatedOrders = List<IOrder>.from(currentOrders)
        ..[orderIndex] = updatedOrder;
      setOrders(updatedOrders);
    }
  }

  setCurrentlyProcessedOrderId(List<ICartItem>? items) {
    final IOrder? foundOrder = orders
        .where(
          (order) => order.isEqualItems(items ?? []),
        )
        .firstOrNull;

    if (foundOrder != null) {
      _currentlyProcessedOrderId.add(foundOrder.uuid);
    } else {
      _currentlyProcessedOrderId.add(null);
    }
  }

  setCurrentlyProcessedDeliveryGroup(IDeliveryMethod? deliveryGroup) {
    _currentlyProcessedDeliveryMethod.add(deliveryGroup);
  }
}
