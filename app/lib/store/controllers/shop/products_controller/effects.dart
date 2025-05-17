part of 'products_controller.dart';

extension ProductsControllerEffects on ProductsController {
  Future<void> fetchHomeProducts() async {
    try {
      if (allProducts.isLoading) {
        return;
      }

      setHomeProductsLoading(true);

      final List<IProductEntry>? fetchedProducts =
          await loadHomeProductsRequest(userController.currentUser!.uuid);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        throw 'No products found';
      }

      final Map<String, IProductEntry> productsMap = {
        for (final el in fetchedProducts) el.uuid: el
      };

      addHomeProducts(productsMap);
    } catch (error) {
      print(error);
    } finally {
      setHomeProductsLoading(false);
    }
  }

  Future<void> fetchProductsWithFilters(ShopFilters? filters,
      {bool reset = false}) async {
    try {
      // fetching first chunk or new filters
      if (reset) {
        setIsLoadingForSearch(true);
        // fetching more data
      } else {
        setLoadingMoreData(true);
      }

      final offset = reset ? 0 : lazyLoadOffset.content;

      final List<IProductEntry>? fetchedProducts =
          await loadProductsByFiltersRequest(
              filters, PRODUCTS_DATA_CHUNK_SIZE, offset, cancelToken);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        setCanFetchMore(false);
        throw 'No new products found for filters';
      }

      final Map<String, IProductEntry> prodcustMap = {
        for (final el in fetchedProducts) el.uuid: el
      };

      addProducts(prodcustMap);
      setLazyLoadOffset(allProducts.content.length);

      if (prodcustMap.length < PRODUCTS_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
    } catch (error) {
      print(error);
    } finally {
      setLoadingMoreData(false);
      setIsLoadingForSearch(false);
    }
  }

  Future<void> fetchProductsForProductOwner(String selectedProductOwner,
      {bool reset = false}) async {
    try {
      // fetching first chunk or new filters
      if (reset) {
        setIsLoadingForSearch(true);
        // fetching more data
      } else {
        setLoadingMoreData(true);
      }

      final offset = reset ? 0 : lazyLoadOffset.content;

      final List<IProductEntry>? fetchedProducts =
          await loadProductsForProductOwnerRequest(selectedProductOwner,
              PRODUCTS_DATA_CHUNK_SIZE, offset, cancelToken);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        setCanFetchMore(false);
        throw 'No new products found for product owner';
      }

      final Map<String, IProductEntry> prodcustMap = {
        for (final el in fetchedProducts) el.uuid: el
      };

      addProducts(prodcustMap);
      setLazyLoadOffset(allProducts.content.length);

      if (prodcustMap.length < PRODUCTS_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
    } catch (error) {
      print(error);
    } finally {
      setLoadingMoreData(false);
      setIsLoadingForSearch(false);
    }
  }
}
