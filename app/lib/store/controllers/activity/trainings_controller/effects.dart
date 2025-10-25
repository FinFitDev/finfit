part of 'trainings_controller.dart';

extension TrainingsControllerEffects on TrainingsController {
  Future<void> fetchTrainings() async {
    try {
      if (userTrainings.isLoading) {
        return;
      }

      setTrainingsLoading(true);

      final List<ITrainingEntry>? fetchedTrainings = await loadTrainingsRequest(
          userController.currentUser!.uuid, TRAINING_DATA_CHUNK_SIZE, 0);

      if (fetchedTrainings == null || fetchedTrainings.isEmpty) {
        throw 'No trainings found';
      }

      final Map<int, ITrainingEntry> transactionsMap = {
        for (final el in fetchedTrainings) el.id: el
      };

      addUserTrainings(transactionsMap);

      // it means we are at the end of the data
      if (transactionsMap.length < TRAINING_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
      setLazyLoadOffset(userTrainings.content.length);
    } catch (error) {
      print(error);
    } finally {
      setTrainingsLoading(false);
    }
  }

  Future<void> lazyLoadMoreTrainings() async {
    try {
      if (userController.currentUser?.uuid == null) {
        throw Exception('Current user is null');
      }
      setLoadingMoreData(true);

      List<ITrainingEntry> parsedTrainingData = await loadTrainingsRequest(
              userController.currentUser!.uuid,
              TRAINING_DATA_CHUNK_SIZE,
              lazyLoadOffset.content) ??
          [];

      Set<int> unique = {};
      parsedTrainingData = parsedTrainingData
          .where((element) => unique.add(element.id))
          .toList();

      Map<int, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.id: el,
      };

      if (values.isNotEmpty) {
        addUserTrainings(values);
        setLazyLoadOffset(userTrainings.content.length);
      }

      // it means we are at the end of the data
      if (values.length < TRAINING_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
    } catch (error) {
      debugPrint("Exception while lazy loading more trainings data: $error");
    } finally {
      setLoadingMoreData(false);
    }
  }
}
