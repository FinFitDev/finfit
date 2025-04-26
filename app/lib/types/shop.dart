import 'package:excerbuys/types/enums.dart';

class SortByData {
  String category;
  SORTING_ORDER sortingOrder;

  SortByData({required this.category, required this.sortingOrder});
}

typedef IStoreMaxRanges = Map<String, double>;
