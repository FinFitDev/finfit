import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/store/selectors/shop/product_owners.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/shop/product_owner/requests.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

class ProductOwnersController {
  CancelToken cancelToken = CancelToken();

  final BehaviorSubject<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      _allProductOwners =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, IProductOwnerEntry>>>
      get allProductOwnersStream => _allProductOwners.stream;
  ContentWithLoading<Map<String, IProductOwnerEntry>> get allProductOwners =>
      _allProductOwners.value;
}

ProductOwnersController productOwnersController = ProductOwnersController();
