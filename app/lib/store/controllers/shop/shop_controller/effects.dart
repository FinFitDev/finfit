part of 'shop_controller.dart';

extension ShopControllerEffects on ShopController {
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

  Future<void> fetchMaxRanges() async {
    try {
      final IStoreMaxRanges? fetchedRanges = await loadMaxPriceRanges();
      if (fetchedRanges == null || fetchedRanges.isEmpty) {
        throw 'No ranges found';
      }
      setMaxRanges(fetchedRanges);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchAvailableCategories() async {
    try {
      final List<String>? fetchedCategories = await loadAvailableCategories();
      if (fetchedCategories == null || fetchedCategories.isEmpty) {
        throw 'No categories found';
      }
      setAvailableCategories(fetchedCategories);
    } catch (error) {
      print(error);
    }
  }
}
