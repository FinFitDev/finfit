import 'package:excerbuys/types/shop.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

int getNumberOfActiveFilters(SortByData? sortBy, SfRangeValues priceRange,
    SfRangeValues finpointsRange, IStoreMaxRanges maxRanges) {
  var sum = 0;
  if (sortBy != null) {
    sum++;
  }
  if (priceRange.start != 0 || priceRange.end != maxRanges['max_price']) {
    sum++;
  }
  if (finpointsRange.start != 0 ||
      finpointsRange.end != maxRanges['max_finpoints']) {
    sum++;
  }
  return sum;
}
