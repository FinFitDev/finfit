import 'package:excerbuys/types/enums.dart';

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
