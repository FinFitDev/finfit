part of 'claims_controller.dart';

extension ClaimControllerEffects on ClaimsController {
  Future<bool> claimReward(BigInt offerId) async {
    try {
      if (isClaiming) {
        return false;
      }
      setIsClaiming(true);

      if (userController.currentUser == null) {
        throw "User is not defined";
      }

      final String? codeResponse = await claimDiscountCodeRequest(
          offerId.toString(), userController.currentUser!.uuid);

      if (codeResponse != null && codeResponse.isNotEmpty) {
        final IOfferEntry? offer = offersController.allOffers.content[offerId];
        if (offer == null) {
          throw 'Invalid offer';
        }
        addClaims({
          codeResponse: IClaimEntry(
              code: codeResponse,
              offer: offer,
              // TODO fix
              createdAt: DateTime.now().toString(),
              validUntil: DateTime.now().add(Duration(days: 6 * 30)).toString())
        });
        await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/claims/.*'));

        userController.subtractUserBalance((offer.points));
        transactionsController.refresh();
        return true;
      }
      return false;
    } catch (err) {
      print("Error claimimng reward");
      return false;
    } finally {
      setIsClaiming(false);
    }
  }

  Future<void> fetchAllClaims() async {
    try {
      setLoadingClaims(true);
      if (userController.currentUser == null) {
        throw "User is not defined";
      }
      final List<IClaimEntry>? fetchedClaims = await loadAllClaimsRequest(
          userController.currentUser!.uuid, cancelToken);
      print(fetchedClaims);

      if (fetchedClaims == null || fetchedClaims.isEmpty) {
        throw 'No claims found';
      }

      final Map<String, IClaimEntry> claimsMap = {
        for (final el in fetchedClaims) el.code: el
      };

      offersController.addAllOffers(extractNewOffersFromClaims(
          claimsMap, offersController.allOffers.content));

      setAllClaims(claimsMap);
    } catch (error) {
      print(error);
    } finally {
      setLoadingClaims(false);
    }
  }
}
