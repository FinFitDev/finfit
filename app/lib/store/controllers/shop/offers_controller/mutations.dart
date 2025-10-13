part of 'offers_controller.dart';

extension OffersControllerMutations on OffersController {
  reset() {
    setAllOffers({});
    setLazyLoadOffset(0);
    setCanFetchMore(true);
    setAllOffersLoading(false);
    setSearchQuery("");
  }

  refresh() async {
    reset();
    refreshAllOffers();
    refreshFeaturedOffers();
  }

  refreshFeaturedOffers() async {
    await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/offers/featured'));
    fetchFeaturedOffers();
  }

  refreshAllOffers() async {
    await Cache.removeKeysByPattern(
      RegExp(r'.*/api/v1/offers(?:\?.*)?$'),
    );
    fetchAllOffers();
  }

  Future<void> loadMoreData() {
    return fetchAllOffers();
  }

  setFeaturedOffers(Map<BigInt, IOfferEntry> offers) {
    final newData = ContentWithLoading(content: offers);
    newData.isLoading = allOffers.isLoading;
    _featuredOffers.add(newData);
  }

  setFeaturedOffersLoading(bool loading) {
    featuredOffers.isLoading = loading;
    _featuredOffers.add(featuredOffers);
  }

  setAllOffers(Map<BigInt, IOfferEntry> offers) {
    _allOffers.add(ContentWithLoading(content: offers));
  }

  addAllOffers(Map<BigInt, IOfferEntry> offers) {
    Map<BigInt, IOfferEntry> newOffers = {...allOffers.content, ...offers};
    final newData = ContentWithLoading(content: newOffers);
    newData.isLoading = allOffers.isLoading;
    _allOffers.add(newData);
  }

  setAllOffersLoading(bool loading) {
    allOffers.isLoading = loading;
    _allOffers.add(allOffers);
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

  setSearchQuery(String query) {
    _searchQuery.add(query);
    setLazyLoadOffset(0);
    fetchAllOffers();
  }

  // setIsLoadingForSearch(bool isLoading) {
  //   _loadingForSearch.add(isLoading);
  // }
}
