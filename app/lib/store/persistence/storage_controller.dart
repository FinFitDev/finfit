import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  SharedPreferences? instance;
  // persistent until device factory reset
  FlutterSecureStorage? hardStorage;

  // get instance (singleton pattern)
  Future<SharedPreferences> getLocalStorageInstance() async {
    instance ??= await SharedPreferences.getInstance();
    return instance!;
  }

  // get all keys from storage
  Future<Set<String>?> getAllKeys() async {
    final instance = await getLocalStorageInstance();
    return instance.getKeys();
  }

  // get hard storage instance (singleton pattern)
  FlutterSecureStorage getHardStorageInstance() {
    hardStorage ??= const FlutterSecureStorage();
    return hardStorage!;
  }

  // Save the state to local storage
  Future<void> saveStateLocal(String key, String state) async {
    final instance = await getLocalStorageInstance();
    await instance.setString(key, state);
  }

  // Load the state from local storage
  Future<String?> loadStateLocal(String key) async {
    final instance = await getLocalStorageInstance();
    return instance.getString(key);
  }

  // Remove the entry from local storage
  Future<bool> removeStateLocal(String key) async {
    final instance = await getLocalStorageInstance();
    return await instance.remove(key);
  }

  Future<bool> clearLocalStorage() async {
    final instance = await storageController.getLocalStorageInstance();
    return await instance.clear();
  }

  // Save the state to local storage
  Future<void> saveStateHard(String key, String state) async {
    final instance = getHardStorageInstance();
    await instance.write(key: key, value: state);
  }

  // Load the state from local storage
  Future<String?> loadStateHard(String key) async {
    final instance = getHardStorageInstance();
    return await instance.read(key: key);
  }
}

StorageController storageController = StorageController();
