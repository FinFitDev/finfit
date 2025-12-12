part of 'app_controller.dart';

extension AppControllerMutations on AppController {
  restoreStateFromStorage() async {
    await restoreAppStateFromStorage();
    await authController.restoreAuthStateFromStorage();
    await userController.restoreCurrentUserStateFromStorage();
    await stravaController.restoreStravaStateFromStorage();
  }

  restoreAppStateFromStorage() async {
    try {
      final String? appLanguageSaved =
          await storageController.loadStateLocal(APP_LANGUAGE_KEY);

      if (appLanguageSaved != null && appLanguageSaved.isNotEmpty) {
        // don't save to storage again
        setAppLanguage(
            LANGUAGE.values.firstWhere(
                (language) => language.languageCode == appLanguageSaved),
            saveToStorage: false);
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  setDeviceId(String id) {
    _deviceId.add(id);
  }

  setInstallTimestamp(DateTime date) {
    _installTimestamp.add(date);
  }

  setAppLanguage(LANGUAGE language, {bool saveToStorage = true}) {
    _appLanguage.add(language);
    if (saveToStorage) {
      storageController.saveStateLocal(APP_LANGUAGE_KEY, language.languageCode);
    }
  }
}
