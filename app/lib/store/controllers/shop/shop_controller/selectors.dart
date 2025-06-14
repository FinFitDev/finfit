part of 'shop_controller.dart';

extension ShopControllerSelectors on ShopController {
  Stream<int> get numberOfActiveFiltersStream => allShopFiltersStream
      .map((a) => getNumberOfActiveFilters(a, maxPriceRanges));

  Stream<String?> get searchValueStream =>
      allShopFiltersStream.map((data) => data?.search ?? '');

  Stream<int> get activeShopCategoryStream =>
      allShopFiltersStream.map((data) => data?.activeShopCategory ?? 0);

  Stream<int> get totalCartFinpointsCostStream =>
      cartItemsStream.map(countTotalCartFinpointsCost);

  Stream<double> get totalCartPriceWithoutDeliveryCostStream =>
      cartItemsStream.map(countTotalCartPrice);

  Stream<double> get totalCartDiscountValueSaved =>
      cartItemsStream.map(getTotalDiscountSavings);

  Stream<double?> get userBalanceMinusCartCost => Rx.combineLatest2(
      userController.userBalanceStream,
      totalCartFinpointsCostStream,
      getUserBalanceMinusCartCost);

  Stream<ShopFilters?> shopPageUpdateTrigger() {
    return Rx.combineLatest5(
      productOwnersController.allProductOwnersStream,
      productsController.allProductsStream,
      productsController.lazyLoadOffsetStream,
      allShopFiltersStream.distinct(),
      selectedProductOwnerStream,
      (ContentWithLoading<Map<String, IProductOwnerEntry>> owners,
          IAllProductsData products,
          ContentWithLoading<int> offset,
          ShopFilters? filters,
          String? selectedOwner) {
        return filters;
      },
    );
  }
}
