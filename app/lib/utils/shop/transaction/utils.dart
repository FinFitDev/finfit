import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

TRANSACTION_TYPE transactionTypeStringToEnum(String stringCategory) {
  switch (stringCategory) {
    case 'REDEEM':
      return TRANSACTION_TYPE.REDEEM;
    case 'RECEIVE':
      return TRANSACTION_TYPE.RECEIVE;
    case 'SEND':
      return TRANSACTION_TYPE.SEND;
    default:
      return TRANSACTION_TYPE.UNKNOWN;
  }
}

Color getTransactionTypeColor(TRANSACTION_TYPE type, ColorScheme colors) {
  switch (type) {
    case TRANSACTION_TYPE.REDEEM:
      return colors.secondary;
    case TRANSACTION_TYPE.SEND:
      return colors.error;
    case TRANSACTION_TYPE.RECEIVE:
      return colors.secondaryContainer;
    default:
      return colors.tertiaryContainer;
  }
}

String getTransactionTypeIcon(TRANSACTION_TYPE type) {
  switch (type) {
    case TRANSACTION_TYPE.REDEEM:
      return 'assets/svg/gift.svg';
    case TRANSACTION_TYPE.SEND:
      return 'assets/svg/arrowSend.svg';
    case TRANSACTION_TYPE.RECEIVE:
      return 'assets/svg/arrowReceive.svg';
    default:
      return 'assets/svg/questionMark.svg';
  }
}

String getTransactionTypeText(
    TRANSACTION_TYPE type, AppLocalizations localizations) {
  switch (type) {
    case TRANSACTION_TYPE.REDEEM:
      return localizations.textTransactionRedeemed;
    case TRANSACTION_TYPE.SEND:
      return localizations.textTransactionSent;
    case TRANSACTION_TYPE.RECEIVE:
      return localizations.textTransactionReceived;
    default:
      return '';
  }
}

String getTransactionTitle(
    TRANSACTION_TYPE type, AppLocalizations localizations) {
  switch (type) {
    case TRANSACTION_TYPE.REDEEM:
      return localizations.textTransactionRewardTitle;
    case TRANSACTION_TYPE.SEND:
      return localizations.textTransactionSentTitle;
    case TRANSACTION_TYPE.RECEIVE:
      return localizations.textTransactionReceivedTitle;
    default:
      return '';
  }
}

Map<BigInt, IOfferEntry> extractNewOffersFromTransactions(
    Map<String, ITransactionEntry> transactions,
    Map<BigInt, IOfferEntry> currentOffers) {
  return Map.fromEntries(
    transactions.values
        .map((transaction) => transaction.offer)
        .whereType<IOfferEntry>()
        .where((offer) => currentOffers[offer.id] == null)
        .map((offer) => MapEntry(offer.id, offer)),
  );
}
