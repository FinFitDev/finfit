import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/store/selectors/shop/products.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/shop/product/requests.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const PRODUCTS_DATA_CHUNK_SIZE = 6; // TODO change
const HOME_PRODUCTS_DATA_LENGTH = 5; // TODO change

typedef IAllProductsData = ContentWithLoading<Map<String, IProductEntry>>;

class ProductsController {
  CancelToken cancelToken = CancelToken();

// fetured products
  final BehaviorSubject<IAllProductsData> _homeProducts =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllProductsData> get homeProductsStream => _homeProducts.stream;
  IAllProductsData get homeProducts => _homeProducts.value;

// all products (for search)
  final BehaviorSubject<IAllProductsData> _allProducts =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllProductsData> get allProductsStream => _allProducts.stream;
  IAllProductsData get allProducts => _allProducts.value;

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;

  final BehaviorSubject<bool> _loadingForSearch = BehaviorSubject.seeded(false);
  Stream<bool> get loadingForSearchStream => _loadingForSearch.stream;
  bool get loadingForSearch => _loadingForSearch.value;
}

ProductsController productsController = ProductsController();
