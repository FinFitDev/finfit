import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/backend/utils.dart';
import 'package:excerbuys/utils/fetching/utils.dart';

class Cache<T> {
  final Map<String, T> _cache = {};

  T? get(String query) => _cache[query];

  void set(String query, T data) {
    _cache[query] = data;
  }
}
