import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/utils/activity/steps.dart';
import 'package:excerbuys/utils/activity/trainings.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

const TRAINING_DATA_CHUNK_SIZE = 5;

class TrainingsController {
  reset() {
    final newData = ContentWithLoading(content: Map<String, ITrainingEntry>());
    newData.isLoading = userTrainings.isLoading;
    _userTrainings.add(newData);

    _canFetchMore.add(true);

    final newLazyLoadData = ContentWithLoading(content: 0);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newLazyLoadData);
  }

  final BehaviorSubject<ContentWithLoading<Map<String, ITrainingEntry>>>
      _userTrainings = BehaviorSubject.seeded(ContentWithLoading(content: {}));
  Stream<ContentWithLoading<Map<String, ITrainingEntry>>>
      get userTrainingsStream => _userTrainings.stream;
  ContentWithLoading<Map<String, ITrainingEntry>> get userTrainings =>
      _userTrainings.value;
  addUserTrainings(Map<String, ITrainingEntry> activity) {
    Map<String, ITrainingEntry> newTrainings = {
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

  final BehaviorSubject<ContentWithLoading<int>> _lazyLoadOffset =
      BehaviorSubject.seeded(ContentWithLoading(content: 0));
  Stream<ContentWithLoading<int>> get lazyLoadOffsetStream =>
      _lazyLoadOffset.stream;
  ContentWithLoading<int> get lazyLoadOffset => _lazyLoadOffset.value;
  setLazyLoadOffset(int newOffset) {
    final newData = ContentWithLoading(content: newOffset);
    newData.isLoading = lazyLoadOffset.isLoading;
    _lazyLoadOffset.add(newData);
  }

  setLoadingMoreData(bool loading) {
    lazyLoadOffset.isLoading = loading;
    _lazyLoadOffset.add(lazyLoadOffset);
  }

  final BehaviorSubject<bool> _canFetchMore = BehaviorSubject.seeded(true);
  Stream<bool> get canFetchMoreStream => _canFetchMore.stream;
  bool get canFetchMore => _canFetchMore.value;
  setCanFetchMore(bool canFetchMore) {
    _canFetchMore.add(canFetchMore);
  }

  Future<void> fetchTrainings() async {
    if (userTrainings.isLoading) {
      return;
    }

    setTrainingsLoading(true);
    setLoadingMoreData(false);

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

      if (userController.currentUser?.id != null) {
        parsedTrainingData = await loadTrainingsRequest(
                userController.currentUser!.id, TRAINING_DATA_CHUNK_SIZE, 0) ??
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
      if (userController.currentUser?.id == null) {
        throw Exception('Current user is null');
      }
      setLoadingMoreData(true);
      await Future.delayed(Duration(milliseconds: 3000));

      List<ITrainingEntry> parsedTrainingData = await loadTrainingsRequest(
              userController.currentUser!.id,
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

TrainingsController trainingsController = TrainingsController();
