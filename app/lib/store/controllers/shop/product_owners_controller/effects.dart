part of 'product_owners_controller.dart';

extension ProductOwnersControllerEffects on ProductOwnersController {
  Future<void> handleOnSearch(String? search) async {
    if (allProductOwners.isLoading) {
      cancelToken.cancel();
    }
    cancelToken = CancelToken();
    fetchProductOwners(search);
  }

  Future<void> fetchProductOwners(String? search) async {
    try {
      setProductOwnersLoading(true);

      final List<IProductOwnerEntry>? fetchedProductOwners =
          await loadProductOwnersBySearchRequest(
              search ?? '', 50, 0, cancelToken);

      if (fetchedProductOwners == null || fetchedProductOwners.isEmpty) {
        throw 'No product owners found';
      }

      final Map<String, IProductOwnerEntry> productOwnersMap = {
        for (final el in fetchedProductOwners) el.uuid: el
      };

      addProductOwners(productOwnersMap);
    } catch (error) {
      print(error);
    } finally {
      setProductOwnersLoading(false);
    }
  }
}
