part of 'strava_controller.dart';

extension StravaControllerEffects on StravaController {
// authorizing all neccessary libs
  Future<void> authorize() async {
    if (userController.currentUser == null) {
      throw "User is not defined";
    }

    authorizeStravaRequest(userController.currentUser!.uuid);
  }

  // Future<void> checkHealthConnectSdk() async {
  //   HealthConnectSdkStatus? status = await Health().getHealthConnectSdkStatus();
  //   if (status != HealthConnectSdkStatus.sdkAvailable) {
  //     await Health().installHealthConnect();
  //     status = await Health().getHealthConnectSdkStatus();
  //   }
  //   setHealthSdkStatus(status ?? HealthConnectSdkStatus.sdkUnavailable);
  // }

  // Future<void> fetchActivity() async {
  //   if (!healthAuthorized) {
  //     print('Health unauthorized');
  //     return;
  //   }

  //   if (Platform.isAndroid &&
  //       healthSdkStatus != HealthConnectSdkStatus.sdkAvailable) {
  //     print('Health connect unauthorized');
  //     return;
  //   }
  //   // await userController
  //   //     .getCurrentUser('afd90984-17ec-456b-a735-0be89e48300f');

  //   // await userController.getCurrentUser('b1588072-8da4-4ab2-a79e-70816401d3f6');

  //   setTodaysPoints(0);
  //   await trainingsController.fetchTrainings();
  //   await stepsController.fetchsSteps();
  //   userController.addUserBalance(totalPointsToAdd);
  //   setPointsToAdd(0);
  // }
}
