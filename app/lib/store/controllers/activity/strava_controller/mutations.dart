part of 'strava_controller.dart';

extension StravaControllerMutations on StravaController {
  reset() {
    _authorized.add(false);
    _enabled.add(false);
  }

  setAuthroized(bool val) {
    _authorized.add(val);
    if (userController.currentUser == null) {
      return;
    }
    storageController.saveStateLocal(
        '${STRAVA_AUTHORIZED_KEY}_${userController.currentUser!.uuid}',
        val.toString());
  }

  restoreStravaStateFromStorage() async {
    try {
      if (userController.currentUser == null) {
        return;
      }
      final String? stravaAuthSaved = await storageController.loadStateLocal(
          '${STRAVA_AUTHORIZED_KEY}_${userController.currentUser!.uuid}');
      final String? stravaEnabledSaved =
          await storageController.loadStateLocal(STRAVA_ENABLED_KEY);

      if (stravaAuthSaved != null && stravaAuthSaved.isNotEmpty) {
        setAuthroized(jsonDecode(stravaAuthSaved));
      }

      if (stravaEnabledSaved != null && stravaEnabledSaved.isNotEmpty) {
        setEnabled(jsonDecode(stravaEnabledSaved));
      }
    } catch (err) {
      print('Loading data from storage failed $err');
    }
  }

  setEnabled(bool val) {
    _enabled.add(val);
    storageController.saveStateLocal(STRAVA_ENABLED_KEY, val.toString());
  }

  toggleEnabled() {
    _enabled.add(!enabled);
  }

  setUpdatingPermission(bool val) {
    _updatingPermission.add(val);
  }
}
