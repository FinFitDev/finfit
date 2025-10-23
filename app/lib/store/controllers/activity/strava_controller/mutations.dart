part of 'strava_controller.dart';

extension StravaControllerMutations on StravaController {
  reset() {
    trainingsController.reset();
  }

  setHealthAuth(bool isAuth) {
    _healthAuthorized.add(isAuth);
  }

  setHealthSdkStatus(HealthConnectSdkStatus status) {
    __healthSdkStatus.add(status);
  }

  addTodaysPoints(double toAdd) {
    _todaysPoints.add(todaysPoints + toAdd);
  }

  setTodaysPoints(double points) {
    _todaysPoints.add(points);
  }

  compundPointsToAdd(double toAdd) {
    _totalPointsToAdd.add(totalPointsToAdd + toAdd);
  }

  setPointsToAdd(double value) {
    _totalPointsToAdd.add(value);
  }
}
