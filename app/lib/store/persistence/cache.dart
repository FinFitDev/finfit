import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/debug.dart';

class Cache {
  static Future<bool> clearCache() async {
    return await storageController.clearLocalStorage();
  }

  static Future<bool> removeKeysByPattern(RegExp regex) async {
    final List<bool> responses = [];
    final keys = await storageController.getAllKeys() ?? {};
    for (final key in keys) {
      if (regex.hasMatch(key)) {
        responses.add(await storageController.removeStateLocal(key));
      }
    }

    return responses.every((el) => el);
  }

  static Future<ContentWithTimestamp<T>?> get<T>(
      String url, T Function(Object jsonData) deserializer) async {
    final data = await storageController.loadStateLocal(url);
    if (data == null) {
      return null;
    }
    return ContentWithTimestamp.fromJson(data, deserializer);
  }

  static Future<void> set<T>(
      String url, T data, Object Function(T content) serializer,
      {int? validFor}) async {
    var payload = ContentWithTimestamp(content: data);
    if (validFor != null) {
      payload = ContentWithTimestamp(content: data, validFor: validFor);
    }
    await storageController.saveStateLocal(url, payload.toJson(serializer));
  }

  static Future<T?> fetch<T>(
      String url,
      Future<T?> Function() requestFunction,
      Object Function(T content) serializer,
      T Function(Object jsonData) deserializer,
      {int? validFor}) async {
    try {
      final cacheResponse = await Cache.get<T>(url, deserializer);

      if (cacheResponse != null && !cacheResponse.isExpired()) {
        print('Cache hit for $url');
        return cacheResponse.content;
      }

      final response = await requestFunction();
      print('fetch hit for $url');

      if (response != null) {
        await Cache.set(url, response, serializer, validFor: validFor);
      }

      return response;
    } catch (error) {
      print('Cache error $error');
      return null;
    }
  }
}
