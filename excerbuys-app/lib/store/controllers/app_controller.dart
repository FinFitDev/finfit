import 'package:excerbuys/store/controllers/auth_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/store/persistence/storage_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class AppController {
  restoreStateFromStorage() async {
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
  }

  final BehaviorSubject<String> _deviceId =
      BehaviorSubject.seeded('unknown_device');
  Stream<String> get deviceIdStream => _deviceId.stream;
  String get deviceId => _deviceId.value;
  setDeviceId(String id) {
    _deviceId.add(id);
  }

  final BehaviorSubject<DateTime> _installTimestamp =
      BehaviorSubject.seeded(DateTime.now());
  Stream<DateTime> get installTimestampStream => _installTimestamp.stream;
  DateTime get installTimestamp => _installTimestamp.value;
  setInstallTimestamp(DateTime date) {
    _installTimestamp.add(date);
  }

  Future<void> getDeviceId() async {
    final String? persistedDeviceId =
        await storageController.loadStateHard(DEVICE_ID_KEY);
    String? deviceId;

    if (persistedDeviceId != null) {
      deviceId = persistedDeviceId;
    } else {
      deviceId = Uuid().v4();
      await storageController.saveStateHard(DEVICE_ID_KEY, deviceId);
    }
    setDeviceId(deviceId);
  }

  Future<void> getInstallTimestamp() async {
    final String? persistedInstallTimestamp =
        await storageController.loadStateLocal(INSTALL_TIMESTAMP_KEY);
    if (persistedInstallTimestamp != null) {
      setInstallTimestamp(DateTime.parse(persistedInstallTimestamp));
    } else {
      setInstallTimestamp(DateTime.now());
      await storageController.saveStateLocal(
          INSTALL_TIMESTAMP_KEY, DateTime.now().toString());
    }
  }
}

AppController appController = AppController();
