part of 'product_owners_controller.dart';

extension ProductOwnersControllerSelectors on ProductOwnersController {
  Stream<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      get searchProductOwners => Rx.combineLatest2(allProductOwnersStream,
              shopController.searchValueStream, getSearchProductOwners)
          .shareReplay(maxSize: 1);
}
