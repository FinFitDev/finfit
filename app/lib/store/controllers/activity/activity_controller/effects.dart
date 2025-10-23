part of 'activity_controller.dart';

extension ActivityControllerEffects on ActivityController {
  Future<void> fetchActivity() async {
    setTodaysPoints(0);
    await trainingsController.fetchTrainings();
    userController.addUserBalance(totalPointsToAdd);
    setPointsToAdd(0);
  }
}
