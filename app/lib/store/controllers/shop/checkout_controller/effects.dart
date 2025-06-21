part of 'checkout_controller.dart';

extension CheckoutControllerEffects on CheckoutController {
  Future<void> saveCartStateToStorage() async {
    await storageController.saveStateLocal(CART_STATE_KEY,
        jsonEncode(cartItems.map((el) => el.toJson()).toList()));
  }

  Future<void> loadCartStateFromStorage() async {
    final String? serializedCartState =
        await storageController.loadStateLocal(CART_STATE_KEY);

    if (serializedCartState != null) {
      final List<dynamic> parsedData = jsonDecode(serializedCartState);
      final List<ICartItem> cartItemsList =
          parsedData.map((el) => ICartItem.fromJson(el)).toList();
      setCartItems(cartItemsList);
    }
  }

  Future<void> saveUserOrderDataToStorage() async {
    if (userOrderData != null) {
      await storageController.saveStateLocal(
          USER_ORDER_DATA_KEY, jsonEncode(userOrderData!.toJson()));
    }
  }

  Future<void> loadUserOrderDataFromStorage() async {
    final String? serializedOrderData =
        await storageController.loadStateLocal(USER_ORDER_DATA_KEY);

    if (serializedOrderData != null) {
      final Map<String, dynamic> parsedData = jsonDecode(serializedOrderData);
      setUserOrderData(IUserOrderData.fromJson(parsedData));
    }
  }
}
