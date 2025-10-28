part of 'claims_controller.dart';

extension ClaimsControllerMutations on ClaimsController {
  refresh() async {
    await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/claims/.*'));
    setAllClaims({});
    setIsClaiming(false);
    fetchAllClaims();
  }

  setAllClaims(Map<String, IClaimEntry> claims) {
    _allClaims.add(ContentWithLoading(content: claims));
  }

  addClaims(Map<String, IClaimEntry> claims) {
    Map<String, IClaimEntry> newOffers = {...claims, ...allClaims.content};
    final newData = ContentWithLoading(content: newOffers);
    newData.isLoading = allClaims.isLoading;
    _allClaims.add(newData);
  }

  setIsClaiming(bool value) {
    _isClaiming.add(value);
  }

  setLoadingClaims(bool value) {
    allClaims.isLoading = value;
    _allClaims.add(allClaims);
  }
}
