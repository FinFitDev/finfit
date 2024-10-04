import 'package:excerbuys/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  SharedPreferences? instance;

  // get instance (singelton pattern)
  Future<SharedPreferences> getInstance() async {
    instance ??= await SharedPreferences.getInstance();
    return instance!;
  }

  // Save the state to local storage
  Future<void> saveState(String key, String state) async {
    final instance = await getInstance();
    await instance.setString(key, state);
  }

  // Load the state from local storage
  Future<String?> loadState(String key) async {
    final instance = await getInstance();
    return instance.getString(key);
  }
}

StorageController storageController = StorageController();
