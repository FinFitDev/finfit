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
      get affordableProductsStream =>
          allProductsStream.map(getAffordableProducts);

  Stream<ContentWithLoading<List<IProductEntry>>>
      get affordableHomeProductsStream => affordableProductsStream
          .map((entry) => getAffordableHomeProducts(entry, 10));

  Stream<ContentWithLoading<List<IProductEntry>>>
      get nearlyAffordableHomeProducts => allProductsStream
          .map((entry) => getHomeNearlyAffordableProducts(entry, 10));

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
}

ProductsController productsController = ProductsController();
