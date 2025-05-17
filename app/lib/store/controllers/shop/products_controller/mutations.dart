part of 'products_controller.dart';

extension ProductsControllerMutations on ProductsController {
  reset() {
    setProducts({});
    setLazyLoadOffset(0);
    setCanFetchMore(true);
    setProductsLoading(false);
  }

  refresh() async {
    reset();
    final currentOwner = shopController.selectedProductOwner;
    if (currentOwner != null) {
      shopController.setSelectedProductOwner(null);
      await Cache.removeKeysByPattern(
          RegExp(r'.*/api/v1/products/[a-zA-Z0-9\-]+$'));
      await handleOnClickProductOwner(currentOwner);
    } else {
      await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/products'));
      await handleOnChangeFilters(shopController.allShopFilters);
    }
  }

  refreshHomeProducts() async {
    await Cache.removeKeysByPattern(
        RegExp(r'.*/api/v1/products/featured/[a-zA-Z0-9\-]+$'));
    fetchHomeProducts();
  }

  Future<void> loadMoreData() {
    if (shopController.selectedProductOwner != null) {
      return fetchProductsForProductOwner(shopController.selectedProductOwner!);
    } else {
      return fetchProductsWithFilters(shopController.allShopFilters);
    }
  }

  Future<void> handleOnChangeFilters(ShopFilters? filters) async {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    cancelToken = CancelToken();

    setProducts({});
    setLazyLoadOffset(0);
    setCanFetchMore(true);
    fetchProductsWithFilters(filters, reset: true);
  }

  Future<void> handleOnClickProductOwner(String? ownerId) async {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    cancelToken = CancelToken();
    if (shopController.selectedProductOwner == ownerId) {
      return;
    }
    shopController.setSelectedProductOwner(ownerId);

    setProducts({});
    setLazyLoadOffset(0);
    setCanFetchMore(true);
    if (ownerId == null) {
      fetchProductsWithFilters(shopController.allShopFilters, reset: true);
    } else {
      fetchProductsForProductOwner(ownerId, reset: true);
    }
  }

  addHomeProducts(Map<String, IProductEntry> products) {
    Map<String, IProductEntry> newProducts = {
      ...homeProducts.content,
      ...products
    };
    final newData = ContentWithLoading(content: newProducts);
    newData.isLoading = allProducts.isLoading;
    _homeProducts.add(newData);
  }

  setHomeProductsLoading(bool loading) {
    homeProducts.isLoading = loading;
    _homeProducts.add(homeProducts);
  }

  setProducts(Map<String, IProductEntry> products) {
    _allProducts.add(ContentWithLoading(content: products));
  }

  addProducts(Map<String, IProductEntry> products) {
    Map<String, IProductEntry> newProducts = {
      ...allProducts.content,
      ...products
    };
    final newData = ContentWithLoading(content: newProducts);
    newData.isLoading = allProducts.isLoading;
    _allProducts.add(newData);
  }

  setProductsLoading(bool loading) {
    allProducts.isLoading = loading;
    _allProducts.add(allProducts);
  }

  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }

  setIsLoadingForSearch(bool isLoading) {
    _loadingForSearch.add(isLoading);
  }
}
