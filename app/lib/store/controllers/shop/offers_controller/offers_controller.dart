import 'package:dio/dio.dart';
import 'package:excerbuys/store/persistence/cache.dart';
import 'package:excerbuys/store/selectors/offers/offers.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/utils/shop/offers/requests.dart';
import 'package:rxdart/rxdart.dart';

part 'effects.dart';
part 'selectors.dart';
part 'mutations.dart';

const OFFERS_DATA_CHUNK_SIZE = 10; // TODO change
const FEATURED_PRODUCTS_DATA_LENGTH = 5; // TODO change

typedef IAllOffersData = ContentWithLoading<Map<BigInt, IOfferEntry>>;

class OffersController {
  CancelToken cancelToken = CancelToken();

// fetured offers
  final BehaviorSubject<IAllOffersData> _featuredOffers =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllOffersData> get featuredOffersStream => _featuredOffers.stream;
  IAllOffersData get featuredOffers => _featuredOffers.value;

// all products (for search)
  final BehaviorSubject<IAllOffersData> _allOffers =
      BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<IAllOffersData> get allOffersStream => _allOffers.stream;
  IAllOffersData get allOffers => _allOffers.value;

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;

  final BehaviorSubject<String> _searchQuery = BehaviorSubject.seeded('');
  Stream<String> get searchQueryStream => _searchQuery.stream;
  String get searchQuery => _searchQuery.value;
}

OffersController offersController = OffersController();
