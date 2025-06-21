part of 'shop_controller.dart';

extension ShopControllerEffects on ShopController {
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
