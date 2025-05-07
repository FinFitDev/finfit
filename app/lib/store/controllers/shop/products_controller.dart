import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/selectors/shop/products.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:rxdart/rxdart.dart';

const PRODUCTS_DATA_CHUNK_SIZE = 6; // TODO change
const HOME_PRODUCTS_DATA_LENGTH = 5; // TODO change

typedef IAllProductsData = ContentWithLoading<Map<String, IProductEntry>>;

class ProductsController {
  CancelToken cancelToken = CancelToken();

  reset() {
    _allProducts.add(ContentWithLoading(content: {}));
    setLazyLoadOffset(0);
    setCanFetchMore(true);
    setProductsLoading(false);
  }

  refresh() {
    reset();
    handleOnSearch(shopController.searchValue);
  }

//  home products
  final BehaviorSubject<IAllProductsData> _homeProducts =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllProductsData> get homeProductsStream => _homeProducts.stream;
  IAllProductsData get homeProducts => _homeProducts.value;

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

// all products

  final BehaviorSubject<IAllProductsData> _allProducts =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllProductsData> get allProductsStream => _allProducts.stream;
  IAllProductsData get allProducts => _allProducts.value;

  Stream<IAllProductsData> get productsForSearchStream => Rx.combineLatest2(
      allProductsStream,
      shopController.searchValueStream,
      getProductsMatchingSearch);

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

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;
  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;
  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }

  final BehaviorSubject<bool> _loadingForSearch = BehaviorSubject.seeded(false);
  Stream<bool> get loadingForSearchStream => _loadingForSearch.stream;
  bool get loadingForSearch => _loadingForSearch.value;
  setIsLoadingForSearch(bool isLoading) {
    _loadingForSearch.add(isLoading);
  }

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

  Future<void> handleOnSearch(String? search) async {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    cancelToken = CancelToken();
    fetchProductsBySearch(search);
  }

  Future<void> fetchProductsBySearch(String? search) async {
    try {
      if (search != shopController.previousSearchValue) {
        setProducts({});
        setLazyLoadOffset(0);
        setCanFetchMore(true);
        // now the value is the same
        shopController.setPreviousSearchValue(search);
      }

      // fetching more data
      if (lazyLoadOffset.content > 0 &&
          shopController.previousSearchValue == shopController.searchValue) {
        setLoadingMoreData(true);
        // fetching first chunk for search
      } else {
        setIsLoadingForSearch(true);
      }

      final List<IProductEntry>? fetchedProducts =
          await loadProductsBySearchRequest(
              search ?? '',
              PRODUCTS_DATA_CHUNK_SIZE,
              lazyLoadOffset.content ?? 0,
              cancelToken);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        setCanFetchMore(false);
        throw 'No new products found for search $search';
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

ProductsController productsController = ProductsController();
