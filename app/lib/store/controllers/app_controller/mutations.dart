part of 'app_controller.dart';

extension AppControllerMutations on AppController {
  restoreStateFromStorage() async {
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
  }

  setDeviceId(String id) {
    _deviceId.add(id);
  }

  setInstallTimestamp(DateTime date) {
    _installTimestamp.add(date);
  }
}
