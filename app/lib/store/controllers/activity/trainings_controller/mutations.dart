part of 'trainings_controller.dart';

extension TrainingsControllerMutations on TrainingsController {
  reset() {
    final newData = ContentWithLoading(content: Map<int, ITrainingEntry>());
    newData.isLoading = userTrainings.isLoading;
    _userTrainings.add(newData);

    _canFetchMore.add(true);

    final newLazyLoadData = ContentWithLoading(content: 0);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newLazyLoadData);
  }

  refresh() async {
    reset();
    await Cache.removeKeysByPattern(RegExp(r'.*/api/v1/trainings'));
    fetchTrainings();
  }

  addUserTrainings(Map<int, ITrainingEntry> activity) {
    Map<int, ITrainingEntry> newTrainings = {
      ...userTrainings.content,
      ...activity
    };
    final newData = ContentWithLoading(content: newTrainings);
    newData.isLoading = userTrainings.isLoading;
    _userTrainings.add(newData);
  }

  setTrainingsLoading(bool loading) {
    userTrainings.isLoading = loading;
    _userTrainings.add(userTrainings);
  }

  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }
}
