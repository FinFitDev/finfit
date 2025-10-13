part of 'offers_controller.dart';

extension OffersControllerSelectors on OffersController {
  Stream<CombinedOffersData> get combinedOffersStream {
    return Rx.combineLatest4(allOffersStream, featuredOffersStream,
        lazyLoadOffsetStream, searchQueryStream.distinct(), getOffersForSearch);
  }
  // Stream<IAllOffersData> get affordableProductsStream => Rx.combineLatest2(
  //     homeProductsStream,
  //     userController.userBalanceStream,
  //     getAffordableProducts);

  // Stream<ContentWithLoading<List<IProductEntry>>>
  //     get affordableHomeProductsStream =>
  //         affordableProductsStream.map((entry) =>
  //             getAffordableHomeProducts(entry, HOME_PRODUCTS_DATA_LENGTH));

  // Stream<ContentWithLoading<List<IProductEntry>>>
  //     get nearlyAffordableHomeProducts => Rx.combineLatest2(
  //         homeProductsStream,
  //         userController.userBalanceStream,
  //         (entry, balance) => getHomeNearlyAffordableProducts(
  //             entry, balance, HOME_PRODUCTS_DATA_LENGTH));

  // Stream<IAllOffersData> get productsForSearchStream => Rx.combineLatest2(
  //     allProductsStream,
  //     shopController.allShopFiltersStream.distinct(),
  //     getProductsMatchingFilters);
}
