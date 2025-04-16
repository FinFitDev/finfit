import 'package:excerbuys/types/enums.dart';

TRANSACTION_TYPE transactionTypeStringToEnum(String stringCategory) {
  switch (stringCategory) {
    case 'PURCHASE':
      return TRANSACTION_TYPE.PURCHASE;
    case 'RECEIVE':
      return TRANSACTION_TYPE.RECEIVE;
    case 'SEND':
      return TRANSACTION_TYPE.SEND;
    default:
      return TRANSACTION_TYPE.UNKNOWN;
  }
}
