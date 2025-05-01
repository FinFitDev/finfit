import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/selectors/shop/products.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:rxdart/rxdart.dart';

class ProductsController {
  reset() {
    _allProducts.add(ContentWithLoading(content: {}));
    setProductsLoading(false);
  }

  final BehaviorSubject<ContentWithLoading<Map<String, IProductEntry>>>
      _allProducts = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, IProductEntry>>>
      get allProductsStream => _allProducts.stream;
  ContentWithLoading<Map<String, IProductEntry>> get allProducts =>
      _allProducts.value;

  Stream<ContentWithLoading<Map<String, IProductEntry>>>
      get affordableProductsStream => Rx.combineLatest2(allProductsStream,
          userController.userBalanceStream, getAffordableProducts);

  Stream<ContentWithLoading<List<IProductEntry>>>
      get affordableHomeProductsStream => affordableProductsStream
          .map((entry) => getAffordableHomeProducts(entry, 5));

  Stream<ContentWithLoading<List<IProductEntry>>>
      get nearlyAffordableHomeProducts => Rx.combineLatest2(
          allProductsStream,
          userController.userBalanceStream,
          (entry, balance) =>
              getHomeNearlyAffordableProducts(entry, balance, 5));

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

  Future<void> fetchHomeProducts() async {
    try {
      if (allProducts.isLoading) {
        return;
      }

      setProductsLoading(true);

      final List<IProductEntry>? fetchedProducts =
          await loadHomeProductsRequest(userController.currentUser!.uuid);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        throw 'No products found';
      }

      final Map<String, IProductEntry> prodcustMap = {
        for (final el in fetchedProducts) el.uuid: el
      };

      addProducts(prodcustMap);
    } catch (error) {
      print(error);
    } finally {
      setProductsLoading(false);
    }
  }

  Future<void> fetchProductsBySearch() async {
    try {
      if (allProducts.isLoading) {
        return;
      }

      // setProductsLoading(true);

      final List<IProductEntry>? fetchedProducts =
          await loadProductsBySearchRequest('', 10, 0);

      if (fetchedProducts == null || fetchedProducts.isEmpty) {
        throw 'No products found';
      }

      final Map<String, IProductEntry> prodcustMap = {
        for (final el in fetchedProducts) el.uuid: el
      };

      addProducts(prodcustMap);
    } catch (error) {
      print(error);
    } finally {
      // setProductsLoading(false);
    }
  }
}

ProductsController productsController = ProductsController();
