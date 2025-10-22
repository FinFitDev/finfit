import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/shop/reward.dart';

Map<BigInt, IOfferEntry> extractNewOffersFromClaims(
    Map<String, IClaimEntry> claims, Map<BigInt, IOfferEntry> currentOffers) {
  return Map.fromEntries(
    claims.values
        .map((transaction) => transaction.offer)
        .whereType<IOfferEntry>()
        .where((offer) => currentOffers[offer.id] == null)
        .map((offer) => MapEntry(offer.id, offer)),
  );
}
