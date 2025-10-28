part of 'strava_controller.dart';

extension StravaControllerEffects on StravaController {
  Future<void> authorize() async {
    if (userController.currentUser == null) {
      throw "User is not defined";
    }

    final String response =
        await authorizeStravaRequest(userController.currentUser!.uuid);

    if (response == "finfit://strava/auth?success=true") {
      setAuthroized(true);
      setEnabled(true);
    } else {
      final uri = Uri.parse(response);
      final errorMessage = uri.queryParameters['error'];
      print(errorMessage);
      if (errorMessage ==
          'error: duplicate key value violates unique constraint "user_strava_athlete_id_key"') {
        await FlutterPlatformAlert.showAlert(
          windowTitle: "Couldn't connect",
          text:
              'This STRAVA account has already been connected to another user.',
          alertStyle: AlertButtonStyle.ok,
        );
      }
    }
  }

  Future<void> updateEnabled(bool value) async {
    bool prevValue = enabled;
    setEnabled(value);
    try {
      if (updatingPermission) {
        return;
      }
      setUpdatingPermission(true);
      if (userController.currentUser == null) {
        throw "User is not defined";
      }

      final bool response = await updateStravaEnabledRequest(
          userController.currentUser!.uuid, value);

      // rollback
      if (response != true) {
        setEnabled(prevValue);
      }
    } catch (err) {
      setEnabled(prevValue);
    } finally {
      setUpdatingPermission(false);
    }
  }
}
