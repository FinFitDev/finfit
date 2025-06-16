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

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      // Check permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are denied forever.';
      }

      // Get location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setCurrentLocation(position);
    } catch (error) {
      print('Error getting current location: $error');
      return null;
    }
  }
}
