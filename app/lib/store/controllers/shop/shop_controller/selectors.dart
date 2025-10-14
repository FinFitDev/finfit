part of 'shop_controller.dart';

extension ShopControllerSelectors on ShopController {
  Stream<String?> get searchValueStream =>
      allShopFiltersStream.map((data) => data?.search ?? '');

  Stream<int> get activeShopCategoryStream =>
      allShopFiltersStream.map((data) => data?.activeShopCategory ?? 0);
}
