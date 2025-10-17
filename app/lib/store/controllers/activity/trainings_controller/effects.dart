part of 'trainings_controller.dart';

extension TrainingsControllerEffects on TrainingsController {
  Future<void> fetchTrainings() async {
    if (userTrainings.isLoading) {
      return;
    }

    setTrainingsLoading(true);
    setLoadingMoreData(false);

    // await Future.delayed(Duration(milliseconds: 2000)); // TODO remove

    final now = DateTime.now();
    final userCreated = userController.currentUser?.createdAt ?? now;
    final installTimestamp = appController.installTimestamp;
    final Duration differenceUserCreated = now.difference(userCreated);
    final Duration differenceInstallApp = now.difference(installTimestamp);
    final Duration maxDifference = Duration(days: 90);

    // Use the smallest of the three:
    // up to 90 days (we only fetch max up to 3 months of tainings backwards)
    // up to app install date
    // up to user creation date
    final Duration limitedDifference = [
      // TODO: uncomment when we have finished testing
      // differenceInstallApp,
      differenceUserCreated,
      maxDifference,
    ].reduce((a, b) => a.compareTo(b) < 0 ? a : b);

    final prev = now.subtract(limitedDifference);

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: prev,
        endTime: now,
      );

      healthData = filterTrainings(Health().removeDuplicates(healthData));
      List<ITrainingEntry> parsedTrainingData =
          convertTrainingsToRequest(healthData) ?? [];

      if (parsedTrainingData.isNotEmpty) {
        final pointsAwardedResponse =
            await saveTrainingsRequest(parsedTrainingData);
        if (pointsAwardedResponse != null) {
          activityController
              .compundPointsToAdd(double.parse(pointsAwardedResponse));
        }
      }

      if (userController.currentUser?.uuid != null) {
        parsedTrainingData = await loadTrainingsRequest(
                userController.currentUser!.uuid,
                TRAINING_DATA_CHUNK_SIZE,
                0) ??
            [];

        Set<String> unique = {};
        parsedTrainingData = parsedTrainingData
            .where((element) => unique.add(element.uuid))
            .toList();
      }

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
      };

      addUserTrainings(values);

      // it means we are at the end of the data
      if (values.length < TRAINING_DATA_CHUNK_SIZE) {
        setCanFetchMore(false);
      }
      setLazyLoadOffset(userTrainings.content.length);

      final todaysPoints = values.entries
          .where((el) => areDatesEqualRespectToDay(now, el.value.createdAt))
          .fold(0.0, (sum, el) => sum + el.value.points);
      activityController.addTodaysPoints(todaysPoints);
    } catch (error) {
      debugPrint("Exception while extracting trainings data: $error");
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
      // await Future.delayed(Duration(milliseconds: 2000)); // TODO remove

      List<ITrainingEntry> parsedTrainingData = await loadTrainingsRequest(
              userController.currentUser!.uuid,
              TRAINING_DATA_CHUNK_SIZE,
              lazyLoadOffset.content) ??
          [];

      Set<String> unique = {};
      parsedTrainingData = parsedTrainingData
          .where((element) => unique.add(element.uuid))
          .toList();

      Map<String, ITrainingEntry> values = {
        for (var el in parsedTrainingData) el.uuid: el,
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
