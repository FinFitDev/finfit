part of 'app_controller.dart';

extension AppControllerEffects on AppController {
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
