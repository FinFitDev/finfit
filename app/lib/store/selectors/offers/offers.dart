import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/types/shop/offer.dart';

class CombinedOffersData {
  final IAllOffersData featuredOffers;
  final IAllOffersData allOffers;

  CombinedOffersData({
    required this.featuredOffers,
    required this.allOffers,
  });
}

CombinedOffersData getOffersForSearch(
  IAllOffersData all,
  IAllOffersData featured,
  offset,
  String search,
) {
  final normalizedSearch = search.trim().toLowerCase();

  final filteredAllOffers = all.content.entries.where((entry) =>
      normalizedSearch.isEmpty ||
      entry.value.partner.name.toLowerCase().contains(normalizedSearch) ||
      entry.value.description.toLowerCase().contains(normalizedSearch));

  final filteredFeaturedOffers = featured.content.entries.where((entry) =>
      normalizedSearch.isEmpty ||
      entry.value.partner.name.toLowerCase().contains(normalizedSearch) ||
      entry.value.description.toLowerCase().contains(normalizedSearch));

  final sortedAllOffers = filteredAllOffers.toList()
    ..sort((a, b) =>
        b.value.totalRedeemed.compareTo(a.value.totalRedeemed)); // descending

  final sortedFeaturedOffers = filteredFeaturedOffers.toList()
    ..sort((a, b) => b.value.totalRedeemed.compareTo(a.value.totalRedeemed));

  return CombinedOffersData(
    featuredOffers:
        featured.copyWith(content: Map.fromEntries(sortedFeaturedOffers)),
    allOffers: all.copyWith(content: Map.fromEntries(sortedAllOffers)),
  );
}
