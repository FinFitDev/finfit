part of 'offers_controller.dart';

extension ProductsControllerEffects on OffersController {
  Future<void> fetchFeaturedOffers() async {
    try {
      if (allOffers.isLoading) {
        return;
      }

      setFeaturedOffersLoading(true);

      print('fetching offers');
      final List<IOfferEntry>? fetchedOfers = await loadFeaturedOffersRequest();
      print(fetchedOfers);

      if (fetchedOfers == null || fetchedOfers.isEmpty) {
        throw 'No offers found';
      }

      final Map<BigInt, IOfferEntry> offersMap = {
        for (final el in fetchedOfers) el.id: el
      };

      setFeaturedOffers(offersMap);
    } catch (error) {
      print(error);
    } finally {
      setFeaturedOffersLoading(false);
    }
  }

  Future<void> fetchAllOffers({bool reset = false}) async {
    try {
      // fetching first chunk or new filters
      if (lazyLoadOffset.content == 0) {
        setAllOffers(new Map());
      }
      setLoadingMoreData(true);
      final offset = reset ? 0 : lazyLoadOffset.content;

      final List<IOfferEntry>? fetchedOffers = await loadAllOffersRequest(
          searchQuery, OFFERS_DATA_CHUNK_SIZE, offset, cancelToken);

      if (fetchedOffers == null || fetchedOffers.isEmpty) {
        setCanFetchMore(false);
        throw 'No new offers found for filters';
      }

      final Map<BigInt, IOfferEntry> offersMap = {
        for (final el in fetchedOffers) el.id: el
      };

      addAllOffers(offersMap);

      setLazyLoadOffset(allOffers.content.length);

      if (offersMap.length < OFFERS_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      } else {
        setCanFetchMore(true);
      }
    } catch (error) {
      print(error);
    } finally {
      setLoadingMoreData(false);
    }
  }
}
