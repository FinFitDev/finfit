class Cache<T> {
  final Map<String, T> _cache = {};

  T? get(String query) => _cache[query];

  void set(String query, T data) {
    _cache[query] = data;
  }
}
