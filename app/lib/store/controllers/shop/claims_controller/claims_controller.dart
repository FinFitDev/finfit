import 'package:dio/dio.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/shop/reward.dart';
import 'package:excerbuys/utils/shop/claims/requests.dart';
import 'package:excerbuys/utils/shop/claims/utils.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const OFFERS_DATA_CHUNK_SIZE = 6; // TODO change
const FEATURED_PRODUCTS_DATA_LENGTH = 5; // TODO change

// Map<Code, OfferID>
typedef IAllClaimsData = ContentWithLoading<Map<String, IClaimEntry>>;

class ClaimsController {
  CancelToken cancelToken = CancelToken();

  final BehaviorSubject<IAllClaimsData> _allClaims =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllClaimsData> get allClaimsStream => _allClaims.stream;
  IAllClaimsData get allClaims => _allClaims.value;

  final BehaviorSubject<bool> _isClaiming = BehaviorSubject.seeded(false);
  Stream<bool> get isClaimingStream => _isClaiming.stream;
  bool get isClaiming => _isClaiming.value;

  // final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
  //     BehaviorSubject.seeded(ContentWithLoading(content: 0));
  // Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
  //     _lazyLoadOffset.stream;
  // ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  // final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  // Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  // bool get canFetchMore => _canFetchMore.value;

  // final BehaviorSubject<String> _searchQuery = BehaviorSubject.seeded('');
  // Stream<String> get searchQueryStream => _searchQuery.stream;
  // String get searchQuery => _searchQuery.value;
}

ClaimsController claimsController = ClaimsController();
