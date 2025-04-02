import 'package:excerbuys/types/enums.dart';

PRODUCT_CATEGORY productCategoryStringToEnum(String stringCategory) {
  switch (stringCategory) {
    case 'Supplements':
      return PRODUCT_CATEGORY.SUPPLEMENTS;
    default:
      return PRODUCT_CATEGORY.UNKNOWN;
  }
}
