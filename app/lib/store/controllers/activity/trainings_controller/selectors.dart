part of 'trainings_controller.dart';

extension TrainingsControllerSelectors on TrainingsController {
  Stream<ContentWithLoading<Map<int, ITrainingEntry>>> get sortedWorkouts {
    return userTrainingsStream.map(getSortedRecentTrainings);
  }
}
