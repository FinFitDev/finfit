part of 'activity_controller.dart';

extension ActivityControllerEffects on ActivityController {
// authorizing all neccessary libs
  Future<void> authorize() async {
    if (await Permission.activityRecognition.status.isDenied) {
      await Permission.activityRecognition.request();
    }
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
    final List<HealthDataType> types = HEALTH_DATA_TYPES;

    final List<HealthDataAccess> permissions = HEALTH_DATA_PERMISSIONS;

    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    if (hasPermissions == null || !hasPermissions) {
      try {
        final bool authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
        setHealthAuth(authorized);
      } catch (error) {
        debugPrint("Couldn't authorize health: $error");
        setHealthAuth(false);
      }
    } else {
      setHealthAuth(true);
    }
  }

  Future<void> checkHealthConnectSdk() async {
    HealthConnectSdkStatus? status = await Health().getHealthConnectSdkStatus();
    if (status != HealthConnectSdkStatus.sdkAvailable) {
      await Health().installHealthConnect();
      status = await Health().getHealthConnectSdkStatus();
    }
    setHealthSdkStatus(status ?? HealthConnectSdkStatus.sdkUnavailable);
  }

  Future<void> fetchActivity() async {
    if (!healthAuthorized) {
      print('Health unauthorized');
      return;
    }

    if (Platform.isAndroid &&
        healthSdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      print('Health connect unauthorized');
      return;
    }
    // await userController
    //     .getCurrentUser('afd90984-17ec-456b-a735-0be89e48300f');

    // await userController.getCurrentUser('b1588072-8da4-4ab2-a79e-70816401d3f6');

    setTodaysPoints(0);
    await trainingsController.fetchTrainings();
    await stepsController.fetchsSteps();
    userController.addUserBalance(totalPointsToAdd);
    setPointsToAdd(0);
  }
}
