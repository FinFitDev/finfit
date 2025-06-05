part of 'product_owners_controller.dart';

extension ProductOwnersControllerMutations on ProductOwnersController {
  reset() {
    _allProductOwners.add(ContentWithLoading(content: {}));
    setProductOwnersLoading(false);
  }

  refresh() async {
    reset();
    await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/product_owners'));
    handleOnSearch(shopController.allShopFilters?.search ?? '');
  }

  addProductOwners(Map<String, IProductOwnerEntry> owners) {
    Map<String, IProductOwnerEntry> newProductOwners = {
      ...allProductOwners.content,
      ...owners
    };
    final newData = ContentWithLoading(content: newProductOwners);
    newData.isLoading = allProductOwners.isLoading;
    _allProductOwners.add(newData);
  }

  setProductOwnersLoading(bool loading) {
    allProductOwners.isLoading = loading;
    _allProductOwners.add(allProductOwners);
  }
}
