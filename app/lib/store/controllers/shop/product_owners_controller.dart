import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/store/selectors/shop/product_owners.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/shop/product_owner/requests.dart';
import 'package:rxdart/rxdart.dart';

class ProductOwnersController {
  CancelToken cancelToken = CancelToken();

  reset() {
    _allProductOwners.add(ContentWithLoading(content: {}));
    setProductOwnersLoading(false);
  }

  refresh() {
    reset();
    handleOnSearch(shopController.allShopFilters?.search ?? '');
  }

  final BehaviorSubject<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      _allProductOwners =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      get allProductOwnersStream => _allProductOwners.stream;
  ContentWithLoading<Map<String, IProductOwnerEntry>> get allProductOwners =>
      _allProductOwners.value;

  Stream<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      get searchProductOwners => Rx.combineLatest2(allProductOwnersStream,
              shopController.searchValueStream, getSearchProductOwners)
          .shareReplay(maxSize: 1);

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

ProductOwnersController productOwnersController = ProductOwnersController();
