part of 'products_controller.dart';

extension ProductsControllerSelectors on ProductsController {
  Stream<IAllProductsData> get affordableProductsStream => Rx.combineLatest2(
      homeProductsStream,
      userController.userBalanceStream,
      getAffordableProducts);

  Stream<ContentWithLoading<List<IProductEntry>>>
      get affordableHomeProductsStream =>
          affordableProductsStream.map((entry) =>
              getAffordableHomeProducts(entry, HOME_PRODUCTS_DATA_LENGTH));

  Stream<ContentWithLoading<List<IProductEntry>>>
      get nearlyAffordableHomeProducts => Rx.combineLatest2(
          homeProductsStream,
          userController.userBalanceStream,
          (entry, balance) => getHomeNearlyAffordableProducts(
              entry, balance, HOME_PRODUCTS_DATA_LENGTH));

  Stream<IAllProductsData> get productsForSearchStream => Rx.combineLatest2(
      allProductsStream,
      shopController.allShopFiltersStream.distinct(),
      getProductsMatchingFilters);
}
